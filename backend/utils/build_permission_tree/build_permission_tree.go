package build_permission_tree

import "union-system/internal/domain"

type PermissionNode struct {
	domain.Permission
	Children []*PermissionNode `json:"children,omitempty"`
}

func BuildPermissionTree(permissions []domain.Permission) []*PermissionNode {
	// Create a map to hold the nodes by their ID
	nodes := make(map[uint]*PermissionNode)

	// First pass: create nodes for each permission
	for _, permission := range permissions {
		nodes[permission.PermissionID] = &PermissionNode{
			Permission: permission,
		}
	}

	// Second pass: assign children to their parents
	var roots []*PermissionNode
	for _, node := range nodes {
		if node.Permission.ParentPermissionID == 0 {
			// If the node has no parent, it's a root node
			roots = append(roots, node)
		} else {
			// Otherwise, it's a child node, so append it to its parent's children
			parent := nodes[node.Permission.ParentPermissionID]
			parent.Children = append(parent.Children, node)
		}
	}

	return roots
}
