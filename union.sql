PGDMP  )    #                 |            db_union    16.3    16.3    4           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            5           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            6           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            7           1262    24577    db_union    DATABASE     s   CREATE DATABASE db_union WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.utf8';
    DROP DATABASE db_union;
                user_HEK3Na    false            8           0    0    DATABASE db_union    ACL     ,   GRANT ALL ON DATABASE db_union TO db_union;
                   user_HEK3Na    false    3639            �            1255    24579    update_modified_column()    FUNCTION     �   CREATE FUNCTION public.update_modified_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.gmt_update = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;
 /   DROP FUNCTION public.update_modified_column();
       public          user_HEK3Na    false            �            1259    24580    tb_activity    TABLE     �  CREATE TABLE public.tb_activity (
    activity_id integer NOT NULL,
    activity_name character varying(100) NOT NULL,
    description text,
    start_time timestamp(6) without time zone NOT NULL,
    end_time timestamp(6) without time zone NOT NULL,
    location character varying(100),
    participant_limit integer NOT NULL,
    activity_type_id integer NOT NULL,
    creator_id integer NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    removed boolean DEFAULT false NOT NULL
);
    DROP TABLE public.tb_activity;
       public         heap    db_union    false            9           0    0    TABLE tb_activity    COMMENT     1   COMMENT ON TABLE public.tb_activity IS '活动';
          public          db_union    false    215            :           0    0    COLUMN tb_activity.activity_id    COMMENT     @   COMMENT ON COLUMN public.tb_activity.activity_id IS '活动ID';
          public          db_union    false    215            ;           0    0     COLUMN tb_activity.activity_name    COMMENT     F   COMMENT ON COLUMN public.tb_activity.activity_name IS '活动名称';
          public          db_union    false    215            <           0    0    COLUMN tb_activity.description    COMMENT     >   COMMENT ON COLUMN public.tb_activity.description IS '描述';
          public          db_union    false    215            =           0    0    COLUMN tb_activity.start_time    COMMENT     C   COMMENT ON COLUMN public.tb_activity.start_time IS '开始时间';
          public          db_union    false    215            >           0    0    COLUMN tb_activity.end_time    COMMENT     A   COMMENT ON COLUMN public.tb_activity.end_time IS '结束时间';
          public          db_union    false    215            ?           0    0    COLUMN tb_activity.location    COMMENT     ;   COMMENT ON COLUMN public.tb_activity.location IS '地点';
          public          db_union    false    215            @           0    0 $   COLUMN tb_activity.participant_limit    COMMENT     P   COMMENT ON COLUMN public.tb_activity.participant_limit IS '参与人数限制';
          public          db_union    false    215            A           0    0 #   COLUMN tb_activity.activity_type_id    COMMENT     T   COMMENT ON COLUMN public.tb_activity.activity_type_id IS '活动类型ID，外键';
          public          db_union    false    215            B           0    0    COLUMN tb_activity.creator_id    COMMENT     K   COMMENT ON COLUMN public.tb_activity.creator_id IS '创建者ID，外键';
          public          db_union    false    215            C           0    0    COLUMN tb_activity.is_active    COMMENT     B   COMMENT ON COLUMN public.tb_activity.is_active IS '活动有效';
          public          db_union    false    215            D           0    0    COLUMN tb_activity.removed    COMMENT     I   COMMENT ON COLUMN public.tb_activity.removed IS '活动被删除标记';
          public          db_union    false    215            �            1259    24587    tb_activity_activity_id_seq    SEQUENCE     �   CREATE SEQUENCE public.tb_activity_activity_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;
 2   DROP SEQUENCE public.tb_activity_activity_id_seq;
       public          db_union    false    215            E           0    0    tb_activity_activity_id_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public.tb_activity_activity_id_seq OWNED BY public.tb_activity.activity_id;
          public          db_union    false    216            �            1259    24588    tb_activity_type    TABLE     �   CREATE TABLE public.tb_activity_type (
    activity_type_id integer NOT NULL,
    type_name character varying(50) NOT NULL,
    del_flag boolean DEFAULT false NOT NULL
);
 $   DROP TABLE public.tb_activity_type;
       public         heap    db_union    false            F           0    0    TABLE tb_activity_type    COMMENT     <   COMMENT ON TABLE public.tb_activity_type IS '活动类型';
          public          db_union    false    217            G           0    0 (   COLUMN tb_activity_type.activity_type_id    COMMENT     P   COMMENT ON COLUMN public.tb_activity_type.activity_type_id IS '活动类型ID';
          public          db_union    false    217            H           0    0 !   COLUMN tb_activity_type.type_name    COMMENT     G   COMMENT ON COLUMN public.tb_activity_type.type_name IS '类型名称';
          public          db_union    false    217            I           0    0     COLUMN tb_activity_type.del_flag    COMMENT     F   COMMENT ON COLUMN public.tb_activity_type.del_flag IS '删除标记';
          public          db_union    false    217            �            1259    24592 %   tb_activity_type_activity_type_id_seq    SEQUENCE     �   CREATE SEQUENCE public.tb_activity_type_activity_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;
 <   DROP SEQUENCE public.tb_activity_type_activity_type_id_seq;
       public          db_union    false    217            J           0    0 %   tb_activity_type_activity_type_id_seq    SEQUENCE OWNED BY     o   ALTER SEQUENCE public.tb_activity_type_activity_type_id_seq OWNED BY public.tb_activity_type.activity_type_id;
          public          db_union    false    218            �            1259    24593    tb_assistance_request    TABLE     x  CREATE TABLE public.tb_assistance_request (
    request_id integer NOT NULL,
    member_id integer NOT NULL,
    type_id integer NOT NULL,
    description text NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    status_id integer NOT NULL,
    title character varying(100)
);
 )   DROP TABLE public.tb_assistance_request;
       public         heap    db_union    false            K           0    0    TABLE tb_assistance_request    COMMENT     V   COMMENT ON TABLE public.tb_assistance_request IS '存储工会会员的援助请求';
          public          db_union    false    219            L           0    0 '   COLUMN tb_assistance_request.request_id    COMMENT     _   COMMENT ON COLUMN public.tb_assistance_request.request_id IS '援助请求的唯一标识符';
          public          db_union    false    219            M           0    0 &   COLUMN tb_assistance_request.member_id    COMMENT     W   COMMENT ON COLUMN public.tb_assistance_request.member_id IS '发起请求的会员ID';
          public          db_union    false    219            N           0    0 $   COLUMN tb_assistance_request.type_id    COMMENT     U   COMMENT ON COLUMN public.tb_assistance_request.type_id IS '请求的援助类型ID';
          public          db_union    false    219            O           0    0 (   COLUMN tb_assistance_request.description    COMMENT     W   COMMENT ON COLUMN public.tb_assistance_request.description IS '请求的具体描述';
          public          db_union    false    219            P           0    0 '   COLUMN tb_assistance_request.created_at    COMMENT     Y   COMMENT ON COLUMN public.tb_assistance_request.created_at IS '请求创建的时间戳';
          public          db_union    false    219            Q           0    0 '   COLUMN tb_assistance_request.updated_at    COMMENT     _   COMMENT ON COLUMN public.tb_assistance_request.updated_at IS '请求最后更新的时间戳';
          public          db_union    false    219            R           0    0 &   COLUMN tb_assistance_request.status_id    COMMENT     ]   COMMENT ON COLUMN public.tb_assistance_request.status_id IS '引用的援助请求状态ID';
          public          db_union    false    219            S           0    0 "   COLUMN tb_assistance_request.title    COMMENT     H   COMMENT ON COLUMN public.tb_assistance_request.title IS '援助标题';
          public          db_union    false    219            �            1259    24599 $   tb_assistance_request_request_id_seq    SEQUENCE     �   CREATE SEQUENCE public.tb_assistance_request_request_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;
 ;   DROP SEQUENCE public.tb_assistance_request_request_id_seq;
       public          db_union    false    219            T           0    0 $   tb_assistance_request_request_id_seq    SEQUENCE OWNED BY     m   ALTER SEQUENCE public.tb_assistance_request_request_id_seq OWNED BY public.tb_assistance_request.request_id;
          public          db_union    false    220            �            1259    24600    tb_assistance_response    TABLE       CREATE TABLE public.tb_assistance_response (
    response_id integer NOT NULL,
    request_id integer NOT NULL,
    responder_id integer NOT NULL,
    response_text text NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
 *   DROP TABLE public.tb_assistance_response;
       public         heap    db_union    false            U           0    0    TABLE tb_assistance_response    COMMENT     T   COMMENT ON TABLE public.tb_assistance_response IS '存储对援助请求的回复';
          public          db_union    false    221            V           0    0 )   COLUMN tb_assistance_response.response_id    COMMENT     [   COMMENT ON COLUMN public.tb_assistance_response.response_id IS '回复的唯一标识符';
          public          db_union    false    221            W           0    0 (   COLUMN tb_assistance_response.request_id    COMMENT     \   COMMENT ON COLUMN public.tb_assistance_response.request_id IS '关联的援助请求的ID';
          public          db_union    false    221            X           0    0 *   COLUMN tb_assistance_response.responder_id    COMMENT     X   COMMENT ON COLUMN public.tb_assistance_response.responder_id IS '回复者的用户ID';
          public          db_union    false    221            Y           0    0 +   COLUMN tb_assistance_response.response_text    COMMENT     Z   COMMENT ON COLUMN public.tb_assistance_response.response_text IS '回复的具体内容';
          public          db_union    false    221            Z           0    0 (   COLUMN tb_assistance_response.created_at    COMMENT     Z   COMMENT ON COLUMN public.tb_assistance_response.created_at IS '回复创建的时间戳';
          public          db_union    false    221            �            1259    24606 &   tb_assistance_response_response_id_seq    SEQUENCE     �   CREATE SEQUENCE public.tb_assistance_response_response_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;
 =   DROP SEQUENCE public.tb_assistance_response_response_id_seq;
       public          db_union    false    221            [           0    0 &   tb_assistance_response_response_id_seq    SEQUENCE OWNED BY     q   ALTER SEQUENCE public.tb_assistance_response_response_id_seq OWNED BY public.tb_assistance_response.response_id;
          public          db_union    false    222            �            1259    24607    tb_assistance_status    TABLE     }   CREATE TABLE public.tb_assistance_status (
    status_id integer NOT NULL,
    status_name character varying(50) NOT NULL
);
 (   DROP TABLE public.tb_assistance_status;
       public         heap    db_union    false            \           0    0    TABLE tb_assistance_status    COMMENT     [   COMMENT ON TABLE public.tb_assistance_status IS '定义所有可能的援助请求状态';
          public          db_union    false    223            ]           0    0 %   COLUMN tb_assistance_status.status_id    COMMENT     W   COMMENT ON COLUMN public.tb_assistance_status.status_id IS '状态的唯一标识符';
          public          db_union    false    223            ^           0    0 '   COLUMN tb_assistance_status.status_name    COMMENT     P   COMMENT ON COLUMN public.tb_assistance_status.status_name IS '状态的名称';
          public          db_union    false    223            �            1259    24610 "   tb_assistance_status_status_id_seq    SEQUENCE     �   CREATE SEQUENCE public.tb_assistance_status_status_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;
 9   DROP SEQUENCE public.tb_assistance_status_status_id_seq;
       public          db_union    false    223            _           0    0 "   tb_assistance_status_status_id_seq    SEQUENCE OWNED BY     i   ALTER SEQUENCE public.tb_assistance_status_status_id_seq OWNED BY public.tb_assistance_status.status_id;
          public          db_union    false    224            �            1259    24611    tb_assistance_type    TABLE     �   CREATE TABLE public.tb_assistance_type (
    assistance_type_id integer NOT NULL,
    type_name character varying(50) NOT NULL,
    del_flag boolean DEFAULT false NOT NULL
);
 &   DROP TABLE public.tb_assistance_type;
       public         heap    db_union    false            `           0    0    TABLE tb_assistance_type    COMMENT     >   COMMENT ON TABLE public.tb_assistance_type IS '援助类型';
          public          db_union    false    225            a           0    0 ,   COLUMN tb_assistance_type.assistance_type_id    COMMENT     T   COMMENT ON COLUMN public.tb_assistance_type.assistance_type_id IS '援助类型ID';
          public          db_union    false    225            b           0    0 #   COLUMN tb_assistance_type.type_name    COMMENT     I   COMMENT ON COLUMN public.tb_assistance_type.type_name IS '类型名称';
          public          db_union    false    225            c           0    0 "   COLUMN tb_assistance_type.del_flag    COMMENT     H   COMMENT ON COLUMN public.tb_assistance_type.del_flag IS '删除标记';
          public          db_union    false    225            �            1259    24615 )   tb_assistance_type_assistance_type_id_seq    SEQUENCE     �   CREATE SEQUENCE public.tb_assistance_type_assistance_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;
 @   DROP SEQUENCE public.tb_assistance_type_assistance_type_id_seq;
       public          db_union    false    225            d           0    0 )   tb_assistance_type_assistance_type_id_seq    SEQUENCE OWNED BY     w   ALTER SEQUENCE public.tb_assistance_type_assistance_type_id_seq OWNED BY public.tb_assistance_type.assistance_type_id;
          public          db_union    false    226            �            1259    24616    tb_fee_bill    TABLE     �  CREATE TABLE public.tb_fee_bill (
    bill_id integer NOT NULL,
    user_id integer NOT NULL,
    amount numeric(10,2) NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP,
    due_date timestamp(0) without time zone NOT NULL,
    paid boolean DEFAULT false,
    billing_period character varying(6),
    CONSTRAINT check_billing_period_format CHECK (((billing_period)::text ~ '^\d{4}(0[1-9]|1[0-2])$'::text))
);
    DROP TABLE public.tb_fee_bill;
       public         heap    db_union    false            e           0    0    COLUMN tb_fee_bill.bill_id    COMMENT     E   COMMENT ON COLUMN public.tb_fee_bill.bill_id IS '账单ID，主键';
          public          db_union    false    227            f           0    0    COLUMN tb_fee_bill.user_id    COMMENT     [   COMMENT ON COLUMN public.tb_fee_bill.user_id IS '用户ID，外键，关联到tb_user表';
          public          db_union    false    227            g           0    0    COLUMN tb_fee_bill.amount    COMMENT     E   COMMENT ON COLUMN public.tb_fee_bill.amount IS '应缴费用金额';
          public          db_union    false    227            h           0    0    COLUMN tb_fee_bill.created_at    COMMENT     I   COMMENT ON COLUMN public.tb_fee_bill.created_at IS '账单创建时间';
          public          db_union    false    227            i           0    0    COLUMN tb_fee_bill.due_date    COMMENT     M   COMMENT ON COLUMN public.tb_fee_bill.due_date IS '账单缴费截止日期';
          public          db_union    false    227            j           0    0    COLUMN tb_fee_bill.paid    COMMENT     j   COMMENT ON COLUMN public.tb_fee_bill.paid IS '缴费状态，FALSE表示未支付，TRUE表示已支付';
          public          db_union    false    227            k           0    0 !   COLUMN tb_fee_bill.billing_period    COMMENT     z   COMMENT ON COLUMN public.tb_fee_bill.billing_period IS '账单周期，格式为YYYYMM，表示账单属于哪个年月';
          public          db_union    false    227            �            1259    24622    tb_fee_bill_bill_id_seq    SEQUENCE     �   CREATE SEQUENCE public.tb_fee_bill_bill_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;
 .   DROP SEQUENCE public.tb_fee_bill_bill_id_seq;
       public          db_union    false    227            l           0    0    tb_fee_bill_bill_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.tb_fee_bill_bill_id_seq OWNED BY public.tb_fee_bill.bill_id;
          public          db_union    false    228            �            1259    24623    tb_fee_standard_new    TABLE     �   CREATE TABLE public.tb_fee_standard_new (
    standard_id integer NOT NULL,
    standard_amount numeric(8,2) NOT NULL,
    standard_name character varying(30) DEFAULT ''::character varying NOT NULL
);
 '   DROP TABLE public.tb_fee_standard_new;
       public         heap    db_union    false            m           0    0 &   COLUMN tb_fee_standard_new.standard_id    COMMENT     U   COMMENT ON COLUMN public.tb_fee_standard_new.standard_id IS '费用标准ID 主键';
          public          db_union    false    229            n           0    0 *   COLUMN tb_fee_standard_new.standard_amount    COMMENT     V   COMMENT ON COLUMN public.tb_fee_standard_new.standard_amount IS '会费周期费率';
          public          db_union    false    229            o           0    0 (   COLUMN tb_fee_standard_new.standard_name    COMMENT     T   COMMENT ON COLUMN public.tb_fee_standard_new.standard_name IS '会费标准名称';
          public          db_union    false    229            �            1259    24627 #   tb_fee_standard_new_standard_id_seq    SEQUENCE     �   CREATE SEQUENCE public.tb_fee_standard_new_standard_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 :   DROP SEQUENCE public.tb_fee_standard_new_standard_id_seq;
       public          db_union    false    229            p           0    0 #   tb_fee_standard_new_standard_id_seq    SEQUENCE OWNED BY     k   ALTER SEQUENCE public.tb_fee_standard_new_standard_id_seq OWNED BY public.tb_fee_standard_new.standard_id;
          public          db_union    false    230            �            1259    24628    tb_invitation_codes    TABLE     a  CREATE TABLE public.tb_invitation_codes (
    code_id integer NOT NULL,
    code character varying(255) NOT NULL,
    created_by_user_id integer NOT NULL,
    used_by_user_id integer,
    is_used boolean DEFAULT false NOT NULL,
    created_at timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP,
    expires_at timestamp(6) with time zone NOT NULL
);
 '   DROP TABLE public.tb_invitation_codes;
       public         heap    db_union    false            q           0    0    TABLE tb_invitation_codes    COMMENT     c   COMMENT ON TABLE public.tb_invitation_codes IS '存储邀请码信息，用于注册时验证。';
          public          db_union    false    231            r           0    0 "   COLUMN tb_invitation_codes.code_id    COMMENT     c   COMMENT ON COLUMN public.tb_invitation_codes.code_id IS '邀请码的唯一标识符，主键。';
          public          db_union    false    231            s           0    0    COLUMN tb_invitation_codes.code    COMMENT     W   COMMENT ON COLUMN public.tb_invitation_codes.code IS '邀请码字符串，唯一。';
          public          db_union    false    231            t           0    0 -   COLUMN tb_invitation_codes.created_by_user_id    COMMENT        COMMENT ON COLUMN public.tb_invitation_codes.created_by_user_id IS '生成邀请码的用户ID，引用用户表的主键。';
          public          db_union    false    231            u           0    0 *   COLUMN tb_invitation_codes.used_by_user_id    COMMENT     �   COMMENT ON COLUMN public.tb_invitation_codes.used_by_user_id IS '使用邀请码注册的用户ID，如果未被使用则为NULL。';
          public          db_union    false    231            v           0    0 "   COLUMN tb_invitation_codes.is_used    COMMENT     u   COMMENT ON COLUMN public.tb_invitation_codes.is_used IS '标记邀请码是否已被使用，避免重复使用。';
          public          db_union    false    231            w           0    0 %   COLUMN tb_invitation_codes.created_at    COMMENT     Z   COMMENT ON COLUMN public.tb_invitation_codes.created_at IS '邀请码的创建时间。';
          public          db_union    false    231            x           0    0 %   COLUMN tb_invitation_codes.expires_at    COMMENT     r   COMMENT ON COLUMN public.tb_invitation_codes.expires_at IS '邀请码的过期时间，过期后不能使用。';
          public          db_union    false    231            �            1259    24633    tb_invitation_codes_code_id_seq    SEQUENCE     �   CREATE SEQUENCE public.tb_invitation_codes_code_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;
 6   DROP SEQUENCE public.tb_invitation_codes_code_id_seq;
       public          db_union    false    231            y           0    0    tb_invitation_codes_code_id_seq    SEQUENCE OWNED BY     c   ALTER SEQUENCE public.tb_invitation_codes_code_id_seq OWNED BY public.tb_invitation_codes.code_id;
          public          db_union    false    232            �            1259    24634    tb_log_admin    TABLE       CREATE TABLE public.tb_log_admin (
    log_id integer NOT NULL,
    user_id integer NOT NULL,
    module_id integer NOT NULL,
    ip character varying(39) NOT NULL,
    action_detail text NOT NULL,
    action_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);
     DROP TABLE public.tb_log_admin;
       public         heap    db_union    false            �            1259    24640    tb_log_admin_log_id_seq    SEQUENCE     �   CREATE SEQUENCE public.tb_log_admin_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.tb_log_admin_log_id_seq;
       public          db_union    false    233            z           0    0    tb_log_admin_log_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.tb_log_admin_log_id_seq OWNED BY public.tb_log_admin.log_id;
          public          db_union    false    234            �            1259    24641    tb_log_login    TABLE       CREATE TABLE public.tb_log_login (
    log_id integer NOT NULL,
    ua text NOT NULL,
    ip character varying(39) NOT NULL,
    login_status boolean NOT NULL,
    login_time timestamp(6) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    username character varying
);
     DROP TABLE public.tb_log_login;
       public         heap    db_union    false            {           0    0    COLUMN tb_log_login.log_id    COMMENT     K   COMMENT ON COLUMN public.tb_log_login.log_id IS '日志ID，自增主键';
          public          db_union    false    235            |           0    0    COLUMN tb_log_login.ua    COMMENT     o   COMMENT ON COLUMN public.tb_log_login.ua IS '用户代理字符串，详细描述了用户的浏览器信息';
          public          db_union    false    235            }           0    0    COLUMN tb_log_login.ip    COMMENT     [   COMMENT ON COLUMN public.tb_log_login.ip IS '用户的IP地址，兼容IPv4和IPv6格式';
          public          db_union    false    235            ~           0    0     COLUMN tb_log_login.login_status    COMMENT     g   COMMENT ON COLUMN public.tb_log_login.login_status IS '登录状态，TRUE为成功，FALSE为失败';
          public          db_union    false    235                       0    0    COLUMN tb_log_login.login_time    COMMENT     \   COMMENT ON COLUMN public.tb_log_login.login_time IS '登录时间，默认为当前时间';
          public          db_union    false    235            �           0    0    COLUMN tb_log_login.username    COMMENT     H   COMMENT ON COLUMN public.tb_log_login.username IS '登录的用户名';
          public          db_union    false    235            �            1259    24647    tb_log_login_log_id_seq    SEQUENCE     �   CREATE SEQUENCE public.tb_log_login_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;
 .   DROP SEQUENCE public.tb_log_login_log_id_seq;
       public          db_union    false    235            �           0    0    tb_log_login_log_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.tb_log_login_log_id_seq OWNED BY public.tb_log_login.log_id;
          public          db_union    false    236            �            1259    24648    tb_log_member    TABLE       CREATE TABLE public.tb_log_member (
    log_id integer NOT NULL,
    module_id integer NOT NULL,
    ip character varying(39) NOT NULL,
    action_detail text NOT NULL,
    action_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    user_id integer NOT NULL
);
 !   DROP TABLE public.tb_log_member;
       public         heap    db_union    false            �            1259    24654    tb_log_member_log_id_seq    SEQUENCE     �   CREATE SEQUENCE public.tb_log_member_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.tb_log_member_log_id_seq;
       public          db_union    false    237            �           0    0    tb_log_member_log_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.tb_log_member_log_id_seq OWNED BY public.tb_log_member.log_id;
          public          db_union    false    238            �            1259    24655    tb_log_modules    TABLE     w   CREATE TABLE public.tb_log_modules (
    module_id integer NOT NULL,
    module_name character varying(50) NOT NULL
);
 "   DROP TABLE public.tb_log_modules;
       public         heap    db_union    false            �            1259    24658    tb_log_modules_module_id_seq    SEQUENCE     �   CREATE SEQUENCE public.tb_log_modules_module_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public.tb_log_modules_module_id_seq;
       public          db_union    false    239            �           0    0    tb_log_modules_module_id_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE public.tb_log_modules_module_id_seq OWNED BY public.tb_log_modules.module_id;
          public          db_union    false    240            �            1259    24659    tb_member_fee_info    TABLE     �   CREATE TABLE public.tb_member_fee_info (
    info_id integer NOT NULL,
    user_id integer NOT NULL,
    is_fee_active boolean DEFAULT false,
    fee_start_month character varying(6)
);
 &   DROP TABLE public.tb_member_fee_info;
       public         heap    db_union    false            �            1259    24663    tb_member_fee_info_info_id_seq    SEQUENCE     �   CREATE SEQUENCE public.tb_member_fee_info_info_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;
 5   DROP SEQUENCE public.tb_member_fee_info_info_id_seq;
       public          db_union    false    241            �           0    0    tb_member_fee_info_info_id_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE public.tb_member_fee_info_info_id_seq OWNED BY public.tb_member_fee_info.info_id;
          public          db_union    false    242            �            1259    24664    tb_notification    TABLE       CREATE TABLE public.tb_notification (
    notification_id integer NOT NULL,
    title character varying(255) NOT NULL,
    content text NOT NULL,
    created_at timestamp(6) without time zone DEFAULT CURRENT_TIMESTAMP,
    sender_id integer DEFAULT 0 NOT NULL
);
 #   DROP TABLE public.tb_notification;
       public         heap    db_union    false            �           0    0 &   COLUMN tb_notification.notification_id    COMMENT     H   COMMENT ON COLUMN public.tb_notification.notification_id IS '通知ID';
          public          db_union    false    243            �           0    0    COLUMN tb_notification.title    COMMENT     B   COMMENT ON COLUMN public.tb_notification.title IS '通知标题';
          public          db_union    false    243            �           0    0    COLUMN tb_notification.content    COMMENT     D   COMMENT ON COLUMN public.tb_notification.content IS '通知内容';
          public          db_union    false    243            �           0    0 !   COLUMN tb_notification.created_at    COMMENT     G   COMMENT ON COLUMN public.tb_notification.created_at IS '创建时间';
          public          db_union    false    243            �           0    0     COLUMN tb_notification.sender_id    COMMENT     ^   COMMENT ON COLUMN public.tb_notification.sender_id IS '发送者ID，NULL表示系统通知';
          public          db_union    false    243            �            1259    24671 #   tb_notification_notification_id_seq    SEQUENCE     �   CREATE SEQUENCE public.tb_notification_notification_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;
 :   DROP SEQUENCE public.tb_notification_notification_id_seq;
       public          db_union    false    243            �           0    0 #   tb_notification_notification_id_seq    SEQUENCE OWNED BY     k   ALTER SEQUENCE public.tb_notification_notification_id_seq OWNED BY public.tb_notification.notification_id;
          public          db_union    false    244            �            1259    24672    tb_notification_recipient    TABLE     �   CREATE TABLE public.tb_notification_recipient (
    notification_id integer NOT NULL,
    recipient_id integer NOT NULL,
    read_status boolean DEFAULT false NOT NULL
);
 -   DROP TABLE public.tb_notification_recipient;
       public         heap    db_union    false            �           0    0 0   COLUMN tb_notification_recipient.notification_id    COMMENT     R   COMMENT ON COLUMN public.tb_notification_recipient.notification_id IS '通知ID';
          public          db_union    false    245            �           0    0 -   COLUMN tb_notification_recipient.recipient_id    COMMENT     R   COMMENT ON COLUMN public.tb_notification_recipient.recipient_id IS '接收者ID';
          public          db_union    false    245            �           0    0 ,   COLUMN tb_notification_recipient.read_status    COMMENT     m   COMMENT ON COLUMN public.tb_notification_recipient.read_status IS '阅读状态，FALSE未读，TRUE已读';
          public          db_union    false    245            �            1259    24676    tb_permission    TABLE     &  CREATE TABLE public.tb_permission (
    permission_id integer NOT NULL,
    permission_name character varying(255) NOT NULL,
    description text,
    parent_permission_id integer NOT NULL,
    permission_node character varying(100),
    icon character varying(30),
    gmt_create timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    del_flag boolean DEFAULT false NOT NULL,
    role_type character varying(1) NOT NULL,
    list_hidden boolean,
    list_order integer DEFAULT 0 NOT NULL,
    for_type character varying(10) NOT NULL
);
 !   DROP TABLE public.tb_permission;
       public         heap    db_union    false            �           0    0    TABLE tb_permission    COMMENT     K   COMMENT ON TABLE public.tb_permission IS '存储系统中的操作权限';
          public          db_union    false    246            �           0    0 $   COLUMN tb_permission.permission_name    COMMENT     J   COMMENT ON COLUMN public.tb_permission.permission_name IS '权限名称';
          public          db_union    false    246            �           0    0     COLUMN tb_permission.description    COMMENT     F   COMMENT ON COLUMN public.tb_permission.description IS '权限描述';
          public          db_union    false    246            �           0    0 )   COLUMN tb_permission.parent_permission_id    COMMENT     N   COMMENT ON COLUMN public.tb_permission.parent_permission_id IS '父功能ID';
          public          db_union    false    246            �           0    0 $   COLUMN tb_permission.permission_node    COMMENT     w   COMMENT ON COLUMN public.tb_permission.permission_node IS '权限节点（路由配置，类型为菜单时必选）';
          public          db_union    false    246            �           0    0    COLUMN tb_permission.icon    COMMENT     9   COMMENT ON COLUMN public.tb_permission.icon IS '图标';
          public          db_union    false    246            �           0    0    COLUMN tb_permission.gmt_create    COMMENT     E   COMMENT ON COLUMN public.tb_permission.gmt_create IS '创建时间';
          public          db_union    false    246            �           0    0    COLUMN tb_permission.del_flag    COMMENT     C   COMMENT ON COLUMN public.tb_permission.del_flag IS '逻辑删除';
          public          db_union    false    246            �           0    0    COLUMN tb_permission.role_type    COMMENT     U   COMMENT ON COLUMN public.tb_permission.role_type IS '目录(R) 菜单(L) 按钮(B)';
          public          db_union    false    246            �           0    0     COLUMN tb_permission.list_hidden    COMMENT     L   COMMENT ON COLUMN public.tb_permission.list_hidden IS '菜单是否隐藏';
          public          db_union    false    246            �           0    0    COLUMN tb_permission.list_order    COMMENT     E   COMMENT ON COLUMN public.tb_permission.list_order IS '菜单排序';
          public          db_union    false    246            �           0    0    COLUMN tb_permission.for_type    COMMENT     R   COMMENT ON COLUMN public.tb_permission.for_type IS '权限隶属 ADMIN | MEMBER';
          public          db_union    false    246            �            1259    24684    tb_permission_permission_id_seq    SEQUENCE     �   CREATE SEQUENCE public.tb_permission_permission_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE public.tb_permission_permission_id_seq;
       public          db_union    false    246            �           0    0    tb_permission_permission_id_seq    SEQUENCE OWNED BY     c   ALTER SEQUENCE public.tb_permission_permission_id_seq OWNED BY public.tb_permission.permission_id;
          public          db_union    false    247            �            1259    24685    tb_role_permission    TABLE     m   CREATE TABLE public.tb_role_permission (
    role_id integer NOT NULL,
    permission_id integer NOT NULL
);
 &   DROP TABLE public.tb_role_permission;
       public         heap    db_union    false            �           0    0    TABLE tb_role_permission    COMMENT     J   COMMENT ON TABLE public.tb_role_permission IS '角色和权限的关联';
          public          db_union    false    248            �            1259    24688    tb_user    TABLE     �  CREATE TABLE public.tb_user (
    user_id integer NOT NULL,
    username character varying(50) NOT NULL,
    password character varying(60) NOT NULL,
    email character varying(100),
    phone_number character varying(20),
    registration_date timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    user_type_id integer NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    fee_standard integer DEFAULT '-1'::integer NOT NULL,
    user_role character varying(10) NOT NULL
);
    DROP TABLE public.tb_user;
       public         heap    db_union    false            �           0    0    TABLE tb_user    COMMENT     -   COMMENT ON TABLE public.tb_user IS '用户';
          public          db_union    false    249            �           0    0    COLUMN tb_user.user_id    COMMENT     8   COMMENT ON COLUMN public.tb_user.user_id IS '用户ID';
          public          db_union    false    249            �           0    0    COLUMN tb_user.username    COMMENT     :   COMMENT ON COLUMN public.tb_user.username IS '用户名';
          public          db_union    false    249            �           0    0    COLUMN tb_user.password    COMMENT     7   COMMENT ON COLUMN public.tb_user.password IS '密码';
          public          db_union    false    249            �           0    0    COLUMN tb_user.email    COMMENT     4   COMMENT ON COLUMN public.tb_user.email IS '邮箱';
          public          db_union    false    249            �           0    0    COLUMN tb_user.phone_number    COMMENT     A   COMMENT ON COLUMN public.tb_user.phone_number IS '联系电话';
          public          db_union    false    249            �           0    0     COLUMN tb_user.registration_date    COMMENT     F   COMMENT ON COLUMN public.tb_user.registration_date IS '注册日期';
          public          db_union    false    249            �           0    0    COLUMN tb_user.user_type_id    COMMENT     C   COMMENT ON COLUMN public.tb_user.user_type_id IS '用户权限ID';
          public          db_union    false    249            �           0    0    COLUMN tb_user.is_active    COMMENT     >   COMMENT ON COLUMN public.tb_user.is_active IS '账号状态';
          public          db_union    false    249            �           0    0    COLUMN tb_user.fee_standard    COMMENT     `   COMMENT ON COLUMN public.tb_user.fee_standard IS '会费费率 外键 -1则代表没有关联';
          public          db_union    false    249            �           0    0    COLUMN tb_user.user_role    COMMENT     K   COMMENT ON COLUMN public.tb_user.user_role IS '账号类型 ADMIN/MEMBER';
          public          db_union    false    249            �            1259    24694    tb_user_activity    TABLE     i   CREATE TABLE public.tb_user_activity (
    user_id integer NOT NULL,
    activity_id integer NOT NULL
);
 $   DROP TABLE public.tb_user_activity;
       public         heap    db_union    false            �           0    0    TABLE tb_user_activity    COMMENT     E   COMMENT ON TABLE public.tb_user_activity IS '用户与活动关系';
          public          db_union    false    250            �           0    0    COLUMN tb_user_activity.user_id    COMMENT     A   COMMENT ON COLUMN public.tb_user_activity.user_id IS '用户ID';
          public          db_union    false    250            �           0    0 #   COLUMN tb_user_activity.activity_id    COMMENT     E   COMMENT ON COLUMN public.tb_user_activity.activity_id IS '活动ID';
          public          db_union    false    250            �            1259    24697    tb_user_type    TABLE     �   CREATE TABLE public.tb_user_type (
    type_id integer NOT NULL,
    type_name character varying(50) NOT NULL,
    allow_account_type character varying(10) NOT NULL,
    description character varying(50) NOT NULL
);
     DROP TABLE public.tb_user_type;
       public         heap    db_union    false            �           0    0    TABLE tb_user_type    COMMENT     8   COMMENT ON TABLE public.tb_user_type IS '用户类型';
          public          db_union    false    251            �           0    0    COLUMN tb_user_type.type_id    COMMENT     =   COMMENT ON COLUMN public.tb_user_type.type_id IS '权限ID';
          public          db_union    false    251            �           0    0    COLUMN tb_user_type.type_name    COMMENT     C   COMMENT ON COLUMN public.tb_user_type.type_name IS '权限名称';
          public          db_union    false    251            �           0    0 &   COLUMN tb_user_type.allow_account_type    COMMENT     b   COMMENT ON COLUMN public.tb_user_type.allow_account_type IS '允许的账号类型 ADMIN/MEMBER';
          public          db_union    false    251            �           0    0    COLUMN tb_user_type.description    COMMENT     E   COMMENT ON COLUMN public.tb_user_type.description IS '权限描述';
          public          db_union    false    251            �            1259    24700    tb_user_type_type_id_seq    SEQUENCE     �   CREATE SEQUENCE public.tb_user_type_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;
 /   DROP SEQUENCE public.tb_user_type_type_id_seq;
       public          db_union    false    251            �           0    0    tb_user_type_type_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.tb_user_type_type_id_seq OWNED BY public.tb_user_type.type_id;
          public          db_union    false    252            �            1259    24701    tb_user_user_id_seq    SEQUENCE     �   CREATE SEQUENCE public.tb_user_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1;
 *   DROP SEQUENCE public.tb_user_user_id_seq;
       public          db_union    false    249            �           0    0    tb_user_user_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.tb_user_user_id_seq OWNED BY public.tb_user.user_id;
          public          db_union    false    253                       2604    24702    tb_activity activity_id    DEFAULT     �   ALTER TABLE ONLY public.tb_activity ALTER COLUMN activity_id SET DEFAULT nextval('public.tb_activity_activity_id_seq'::regclass);
 F   ALTER TABLE public.tb_activity ALTER COLUMN activity_id DROP DEFAULT;
       public          db_union    false    216    215                       2604    24703 !   tb_activity_type activity_type_id    DEFAULT     �   ALTER TABLE ONLY public.tb_activity_type ALTER COLUMN activity_type_id SET DEFAULT nextval('public.tb_activity_type_activity_type_id_seq'::regclass);
 P   ALTER TABLE public.tb_activity_type ALTER COLUMN activity_type_id DROP DEFAULT;
       public          db_union    false    218    217                       2604    24704     tb_assistance_request request_id    DEFAULT     �   ALTER TABLE ONLY public.tb_assistance_request ALTER COLUMN request_id SET DEFAULT nextval('public.tb_assistance_request_request_id_seq'::regclass);
 O   ALTER TABLE public.tb_assistance_request ALTER COLUMN request_id DROP DEFAULT;
       public          db_union    false    220    219                       2604    24705 "   tb_assistance_response response_id    DEFAULT     �   ALTER TABLE ONLY public.tb_assistance_response ALTER COLUMN response_id SET DEFAULT nextval('public.tb_assistance_response_response_id_seq'::regclass);
 Q   ALTER TABLE public.tb_assistance_response ALTER COLUMN response_id DROP DEFAULT;
       public          db_union    false    222    221                       2604    24706    tb_assistance_status status_id    DEFAULT     �   ALTER TABLE ONLY public.tb_assistance_status ALTER COLUMN status_id SET DEFAULT nextval('public.tb_assistance_status_status_id_seq'::regclass);
 M   ALTER TABLE public.tb_assistance_status ALTER COLUMN status_id DROP DEFAULT;
       public          db_union    false    224    223                       2604    24707 %   tb_assistance_type assistance_type_id    DEFAULT     �   ALTER TABLE ONLY public.tb_assistance_type ALTER COLUMN assistance_type_id SET DEFAULT nextval('public.tb_assistance_type_assistance_type_id_seq'::regclass);
 T   ALTER TABLE public.tb_assistance_type ALTER COLUMN assistance_type_id DROP DEFAULT;
       public          db_union    false    226    225                       2604    24708    tb_fee_bill bill_id    DEFAULT     z   ALTER TABLE ONLY public.tb_fee_bill ALTER COLUMN bill_id SET DEFAULT nextval('public.tb_fee_bill_bill_id_seq'::regclass);
 B   ALTER TABLE public.tb_fee_bill ALTER COLUMN bill_id DROP DEFAULT;
       public          db_union    false    228    227                       2604    24709    tb_fee_standard_new standard_id    DEFAULT     �   ALTER TABLE ONLY public.tb_fee_standard_new ALTER COLUMN standard_id SET DEFAULT nextval('public.tb_fee_standard_new_standard_id_seq'::regclass);
 N   ALTER TABLE public.tb_fee_standard_new ALTER COLUMN standard_id DROP DEFAULT;
       public          db_union    false    230    229            !           2604    24710    tb_invitation_codes code_id    DEFAULT     �   ALTER TABLE ONLY public.tb_invitation_codes ALTER COLUMN code_id SET DEFAULT nextval('public.tb_invitation_codes_code_id_seq'::regclass);
 J   ALTER TABLE public.tb_invitation_codes ALTER COLUMN code_id DROP DEFAULT;
       public          db_union    false    232    231            $           2604    24711    tb_log_admin log_id    DEFAULT     z   ALTER TABLE ONLY public.tb_log_admin ALTER COLUMN log_id SET DEFAULT nextval('public.tb_log_admin_log_id_seq'::regclass);
 B   ALTER TABLE public.tb_log_admin ALTER COLUMN log_id DROP DEFAULT;
       public          db_union    false    234    233            &           2604    24712    tb_log_login log_id    DEFAULT     z   ALTER TABLE ONLY public.tb_log_login ALTER COLUMN log_id SET DEFAULT nextval('public.tb_log_login_log_id_seq'::regclass);
 B   ALTER TABLE public.tb_log_login ALTER COLUMN log_id DROP DEFAULT;
       public          db_union    false    236    235            (           2604    24713    tb_log_member log_id    DEFAULT     |   ALTER TABLE ONLY public.tb_log_member ALTER COLUMN log_id SET DEFAULT nextval('public.tb_log_member_log_id_seq'::regclass);
 C   ALTER TABLE public.tb_log_member ALTER COLUMN log_id DROP DEFAULT;
       public          db_union    false    238    237            *           2604    24714    tb_log_modules module_id    DEFAULT     �   ALTER TABLE ONLY public.tb_log_modules ALTER COLUMN module_id SET DEFAULT nextval('public.tb_log_modules_module_id_seq'::regclass);
 G   ALTER TABLE public.tb_log_modules ALTER COLUMN module_id DROP DEFAULT;
       public          db_union    false    240    239            +           2604    24715    tb_member_fee_info info_id    DEFAULT     �   ALTER TABLE ONLY public.tb_member_fee_info ALTER COLUMN info_id SET DEFAULT nextval('public.tb_member_fee_info_info_id_seq'::regclass);
 I   ALTER TABLE public.tb_member_fee_info ALTER COLUMN info_id DROP DEFAULT;
       public          db_union    false    242    241            -           2604    24716    tb_notification notification_id    DEFAULT     �   ALTER TABLE ONLY public.tb_notification ALTER COLUMN notification_id SET DEFAULT nextval('public.tb_notification_notification_id_seq'::regclass);
 N   ALTER TABLE public.tb_notification ALTER COLUMN notification_id DROP DEFAULT;
       public          db_union    false    244    243            1           2604    24717    tb_permission permission_id    DEFAULT     �   ALTER TABLE ONLY public.tb_permission ALTER COLUMN permission_id SET DEFAULT nextval('public.tb_permission_permission_id_seq'::regclass);
 J   ALTER TABLE public.tb_permission ALTER COLUMN permission_id DROP DEFAULT;
       public          db_union    false    247    246            5           2604    24718    tb_user user_id    DEFAULT     r   ALTER TABLE ONLY public.tb_user ALTER COLUMN user_id SET DEFAULT nextval('public.tb_user_user_id_seq'::regclass);
 >   ALTER TABLE public.tb_user ALTER COLUMN user_id DROP DEFAULT;
       public          db_union    false    253    249            9           2604    24719    tb_user_type type_id    DEFAULT     |   ALTER TABLE ONLY public.tb_user_type ALTER COLUMN type_id SET DEFAULT nextval('public.tb_user_type_type_id_seq'::regclass);
 C   ALTER TABLE public.tb_user_type ALTER COLUMN type_id DROP DEFAULT;
       public          db_union    false    252    251                      0    24580    tb_activity 
   TABLE DATA           �   COPY public.tb_activity (activity_id, activity_name, description, start_time, end_time, location, participant_limit, activity_type_id, creator_id, is_active, removed) FROM stdin;
    public          db_union    false    215   �2                0    24588    tb_activity_type 
   TABLE DATA           Q   COPY public.tb_activity_type (activity_type_id, type_name, del_flag) FROM stdin;
    public          db_union    false    217   �3                0    24593    tb_assistance_request 
   TABLE DATA           �   COPY public.tb_assistance_request (request_id, member_id, type_id, description, created_at, updated_at, status_id, title) FROM stdin;
    public          db_union    false    219   D4                0    24600    tb_assistance_response 
   TABLE DATA           r   COPY public.tb_assistance_response (response_id, request_id, responder_id, response_text, created_at) FROM stdin;
    public          db_union    false    221   H5                0    24607    tb_assistance_status 
   TABLE DATA           F   COPY public.tb_assistance_status (status_id, status_name) FROM stdin;
    public          db_union    false    223   �5                0    24611    tb_assistance_type 
   TABLE DATA           U   COPY public.tb_assistance_type (assistance_type_id, type_name, del_flag) FROM stdin;
    public          db_union    false    225   	6                0    24616    tb_fee_bill 
   TABLE DATA           k   COPY public.tb_fee_bill (bill_id, user_id, amount, created_at, due_date, paid, billing_period) FROM stdin;
    public          db_union    false    227   Z6                0    24623    tb_fee_standard_new 
   TABLE DATA           Z   COPY public.tb_fee_standard_new (standard_id, standard_amount, standard_name) FROM stdin;
    public          db_union    false    229   �6                0    24628    tb_invitation_codes 
   TABLE DATA           �   COPY public.tb_invitation_codes (code_id, code, created_by_user_id, used_by_user_id, is_used, created_at, expires_at) FROM stdin;
    public          db_union    false    231   =7                0    24634    tb_log_admin 
   TABLE DATA           b   COPY public.tb_log_admin (log_id, user_id, module_id, ip, action_detail, action_time) FROM stdin;
    public          db_union    false    233   `8                0    24641    tb_log_login 
   TABLE DATA           Z   COPY public.tb_log_login (log_id, ua, ip, login_status, login_time, username) FROM stdin;
    public          db_union    false    235   D;      !          0    24648    tb_log_member 
   TABLE DATA           c   COPY public.tb_log_member (log_id, module_id, ip, action_detail, action_time, user_id) FROM stdin;
    public          db_union    false    237   E      #          0    24655    tb_log_modules 
   TABLE DATA           @   COPY public.tb_log_modules (module_id, module_name) FROM stdin;
    public          db_union    false    239   ]G      %          0    24659    tb_member_fee_info 
   TABLE DATA           ^   COPY public.tb_member_fee_info (info_id, user_id, is_fee_active, fee_start_month) FROM stdin;
    public          db_union    false    241   �G      '          0    24664    tb_notification 
   TABLE DATA           a   COPY public.tb_notification (notification_id, title, content, created_at, sender_id) FROM stdin;
    public          db_union    false    243   �G      )          0    24672    tb_notification_recipient 
   TABLE DATA           _   COPY public.tb_notification_recipient (notification_id, recipient_id, read_status) FROM stdin;
    public          db_union    false    245   �      *          0    24676    tb_permission 
   TABLE DATA           �   COPY public.tb_permission (permission_id, permission_name, description, parent_permission_id, permission_node, icon, gmt_create, del_flag, role_type, list_hidden, list_order, for_type) FROM stdin;
    public          db_union    false    246   ��      ,          0    24685    tb_role_permission 
   TABLE DATA           D   COPY public.tb_role_permission (role_id, permission_id) FROM stdin;
    public          db_union    false    248   ��      -          0    24688    tb_user 
   TABLE DATA           �   COPY public.tb_user (user_id, username, password, email, phone_number, registration_date, user_type_id, is_active, fee_standard, user_role) FROM stdin;
    public          db_union    false    249   s�      .          0    24694    tb_user_activity 
   TABLE DATA           @   COPY public.tb_user_activity (user_id, activity_id) FROM stdin;
    public          db_union    false    250   ��      /          0    24697    tb_user_type 
   TABLE DATA           [   COPY public.tb_user_type (type_id, type_name, allow_account_type, description) FROM stdin;
    public          db_union    false    251   ��      �           0    0    tb_activity_activity_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.tb_activity_activity_id_seq', 1009, true);
          public          db_union    false    216            �           0    0 %   tb_activity_type_activity_type_id_seq    SEQUENCE SET     T   SELECT pg_catalog.setval('public.tb_activity_type_activity_type_id_seq', 12, true);
          public          db_union    false    218            �           0    0 $   tb_assistance_request_request_id_seq    SEQUENCE SET     U   SELECT pg_catalog.setval('public.tb_assistance_request_request_id_seq', 1016, true);
          public          db_union    false    220            �           0    0 &   tb_assistance_response_response_id_seq    SEQUENCE SET     W   SELECT pg_catalog.setval('public.tb_assistance_response_response_id_seq', 1041, true);
          public          db_union    false    222            �           0    0 "   tb_assistance_status_status_id_seq    SEQUENCE SET     P   SELECT pg_catalog.setval('public.tb_assistance_status_status_id_seq', 7, true);
          public          db_union    false    224            �           0    0 )   tb_assistance_type_assistance_type_id_seq    SEQUENCE SET     W   SELECT pg_catalog.setval('public.tb_assistance_type_assistance_type_id_seq', 9, true);
          public          db_union    false    226            �           0    0    tb_fee_bill_bill_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.tb_fee_bill_bill_id_seq', 227, true);
          public          db_union    false    228            �           0    0 #   tb_fee_standard_new_standard_id_seq    SEQUENCE SET     Q   SELECT pg_catalog.setval('public.tb_fee_standard_new_standard_id_seq', 4, true);
          public          db_union    false    230            �           0    0    tb_invitation_codes_code_id_seq    SEQUENCE SET     N   SELECT pg_catalog.setval('public.tb_invitation_codes_code_id_seq', 23, true);
          public          db_union    false    232            �           0    0    tb_log_admin_log_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.tb_log_admin_log_id_seq', 33, true);
          public          db_union    false    234            �           0    0    tb_log_login_log_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.tb_log_login_log_id_seq', 229, true);
          public          db_union    false    236            �           0    0    tb_log_member_log_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.tb_log_member_log_id_seq', 42, true);
          public          db_union    false    238            �           0    0    tb_log_modules_module_id_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public.tb_log_modules_module_id_seq', 5, true);
          public          db_union    false    240            �           0    0    tb_member_fee_info_info_id_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('public.tb_member_fee_info_info_id_seq', 50, true);
          public          db_union    false    242            �           0    0 #   tb_notification_notification_id_seq    SEQUENCE SET     T   SELECT pg_catalog.setval('public.tb_notification_notification_id_seq', 1004, true);
          public          db_union    false    244            �           0    0    tb_permission_permission_id_seq    SEQUENCE SET     N   SELECT pg_catalog.setval('public.tb_permission_permission_id_seq', 69, true);
          public          db_union    false    247            �           0    0    tb_user_type_type_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.tb_user_type_type_id_seq', 12, true);
          public          db_union    false    252            �           0    0    tb_user_user_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.tb_user_user_id_seq', 21, true);
          public          db_union    false    253            <           2606    25406    tb_activity tb_activity_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY public.tb_activity
    ADD CONSTRAINT tb_activity_pkey PRIMARY KEY (activity_id);
 F   ALTER TABLE ONLY public.tb_activity DROP CONSTRAINT tb_activity_pkey;
       public            db_union    false    215            >           2606    25408 &   tb_activity_type tb_activity_type_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public.tb_activity_type
    ADD CONSTRAINT tb_activity_type_pkey PRIMARY KEY (activity_type_id);
 P   ALTER TABLE ONLY public.tb_activity_type DROP CONSTRAINT tb_activity_type_pkey;
       public            db_union    false    217            @           2606    25410 0   tb_assistance_request tb_assistance_request_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public.tb_assistance_request
    ADD CONSTRAINT tb_assistance_request_pkey PRIMARY KEY (request_id);
 Z   ALTER TABLE ONLY public.tb_assistance_request DROP CONSTRAINT tb_assistance_request_pkey;
       public            db_union    false    219            B           2606    25412 2   tb_assistance_response tb_assistance_response_pkey 
   CONSTRAINT     y   ALTER TABLE ONLY public.tb_assistance_response
    ADD CONSTRAINT tb_assistance_response_pkey PRIMARY KEY (response_id);
 \   ALTER TABLE ONLY public.tb_assistance_response DROP CONSTRAINT tb_assistance_response_pkey;
       public            db_union    false    221            D           2606    25414 .   tb_assistance_status tb_assistance_status_pkey 
   CONSTRAINT     s   ALTER TABLE ONLY public.tb_assistance_status
    ADD CONSTRAINT tb_assistance_status_pkey PRIMARY KEY (status_id);
 X   ALTER TABLE ONLY public.tb_assistance_status DROP CONSTRAINT tb_assistance_status_pkey;
       public            db_union    false    223            F           2606    25416 9   tb_assistance_status tb_assistance_status_status_name_key 
   CONSTRAINT     {   ALTER TABLE ONLY public.tb_assistance_status
    ADD CONSTRAINT tb_assistance_status_status_name_key UNIQUE (status_name);
 c   ALTER TABLE ONLY public.tb_assistance_status DROP CONSTRAINT tb_assistance_status_status_name_key;
       public            db_union    false    223            H           2606    25418 *   tb_assistance_type tb_assistance_type_pkey 
   CONSTRAINT     x   ALTER TABLE ONLY public.tb_assistance_type
    ADD CONSTRAINT tb_assistance_type_pkey PRIMARY KEY (assistance_type_id);
 T   ALTER TABLE ONLY public.tb_assistance_type DROP CONSTRAINT tb_assistance_type_pkey;
       public            db_union    false    225            J           2606    25420    tb_fee_bill tb_fee_bill_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.tb_fee_bill
    ADD CONSTRAINT tb_fee_bill_pkey PRIMARY KEY (bill_id);
 F   ALTER TABLE ONLY public.tb_fee_bill DROP CONSTRAINT tb_fee_bill_pkey;
       public            db_union    false    227            L           2606    25422 ,   tb_fee_standard_new tb_fee_standard_new_pkey 
   CONSTRAINT     s   ALTER TABLE ONLY public.tb_fee_standard_new
    ADD CONSTRAINT tb_fee_standard_new_pkey PRIMARY KEY (standard_id);
 V   ALTER TABLE ONLY public.tb_fee_standard_new DROP CONSTRAINT tb_fee_standard_new_pkey;
       public            db_union    false    229            N           2606    25424 0   tb_invitation_codes tb_invitation_codes_code_key 
   CONSTRAINT     k   ALTER TABLE ONLY public.tb_invitation_codes
    ADD CONSTRAINT tb_invitation_codes_code_key UNIQUE (code);
 Z   ALTER TABLE ONLY public.tb_invitation_codes DROP CONSTRAINT tb_invitation_codes_code_key;
       public            db_union    false    231            P           2606    25426 ,   tb_invitation_codes tb_invitation_codes_pkey 
   CONSTRAINT     o   ALTER TABLE ONLY public.tb_invitation_codes
    ADD CONSTRAINT tb_invitation_codes_pkey PRIMARY KEY (code_id);
 V   ALTER TABLE ONLY public.tb_invitation_codes DROP CONSTRAINT tb_invitation_codes_pkey;
       public            db_union    false    231            R           2606    25428    tb_log_admin tb_log_admin_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.tb_log_admin
    ADD CONSTRAINT tb_log_admin_pkey PRIMARY KEY (log_id);
 H   ALTER TABLE ONLY public.tb_log_admin DROP CONSTRAINT tb_log_admin_pkey;
       public            db_union    false    233            T           2606    25430    tb_log_login tb_log_login_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.tb_log_login
    ADD CONSTRAINT tb_log_login_pkey PRIMARY KEY (log_id);
 H   ALTER TABLE ONLY public.tb_log_login DROP CONSTRAINT tb_log_login_pkey;
       public            db_union    false    235            V           2606    25432     tb_log_member tb_log_member_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.tb_log_member
    ADD CONSTRAINT tb_log_member_pkey PRIMARY KEY (log_id);
 J   ALTER TABLE ONLY public.tb_log_member DROP CONSTRAINT tb_log_member_pkey;
       public            db_union    false    237            X           2606    25434 -   tb_log_modules tb_log_modules_module_name_key 
   CONSTRAINT     o   ALTER TABLE ONLY public.tb_log_modules
    ADD CONSTRAINT tb_log_modules_module_name_key UNIQUE (module_name);
 W   ALTER TABLE ONLY public.tb_log_modules DROP CONSTRAINT tb_log_modules_module_name_key;
       public            db_union    false    239            Z           2606    25436 "   tb_log_modules tb_log_modules_pkey 
   CONSTRAINT     g   ALTER TABLE ONLY public.tb_log_modules
    ADD CONSTRAINT tb_log_modules_pkey PRIMARY KEY (module_id);
 L   ALTER TABLE ONLY public.tb_log_modules DROP CONSTRAINT tb_log_modules_pkey;
       public            db_union    false    239            \           2606    25438 *   tb_member_fee_info tb_member_fee_info_pkey 
   CONSTRAINT     m   ALTER TABLE ONLY public.tb_member_fee_info
    ADD CONSTRAINT tb_member_fee_info_pkey PRIMARY KEY (info_id);
 T   ALTER TABLE ONLY public.tb_member_fee_info DROP CONSTRAINT tb_member_fee_info_pkey;
       public            db_union    false    241            ^           2606    25440 $   tb_notification tb_notification_pkey 
   CONSTRAINT     o   ALTER TABLE ONLY public.tb_notification
    ADD CONSTRAINT tb_notification_pkey PRIMARY KEY (notification_id);
 N   ALTER TABLE ONLY public.tb_notification DROP CONSTRAINT tb_notification_pkey;
       public            db_union    false    243            `           2606    25442 8   tb_notification_recipient tb_notification_recipient_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.tb_notification_recipient
    ADD CONSTRAINT tb_notification_recipient_pkey PRIMARY KEY (notification_id, recipient_id);
 b   ALTER TABLE ONLY public.tb_notification_recipient DROP CONSTRAINT tb_notification_recipient_pkey;
       public            db_union    false    245    245            b           2606    25444 /   tb_permission tb_permission_permission_name_key 
   CONSTRAINT     u   ALTER TABLE ONLY public.tb_permission
    ADD CONSTRAINT tb_permission_permission_name_key UNIQUE (permission_name);
 Y   ALTER TABLE ONLY public.tb_permission DROP CONSTRAINT tb_permission_permission_name_key;
       public            db_union    false    246            d           2606    25446     tb_permission tb_permission_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY public.tb_permission
    ADD CONSTRAINT tb_permission_pkey PRIMARY KEY (permission_id);
 J   ALTER TABLE ONLY public.tb_permission DROP CONSTRAINT tb_permission_pkey;
       public            db_union    false    246            f           2606    25448 *   tb_role_permission tb_role_permission_pkey 
   CONSTRAINT     |   ALTER TABLE ONLY public.tb_role_permission
    ADD CONSTRAINT tb_role_permission_pkey PRIMARY KEY (role_id, permission_id);
 T   ALTER TABLE ONLY public.tb_role_permission DROP CONSTRAINT tb_role_permission_pkey;
       public            db_union    false    248    248            j           2606    25450 &   tb_user_activity tb_user_activity_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public.tb_user_activity
    ADD CONSTRAINT tb_user_activity_pkey PRIMARY KEY (user_id, activity_id);
 P   ALTER TABLE ONLY public.tb_user_activity DROP CONSTRAINT tb_user_activity_pkey;
       public            db_union    false    250    250            h           2606    25452    tb_user tb_user_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.tb_user
    ADD CONSTRAINT tb_user_pkey PRIMARY KEY (user_id);
 >   ALTER TABLE ONLY public.tb_user DROP CONSTRAINT tb_user_pkey;
       public            db_union    false    249            l           2606    25454    tb_user_type tb_user_type_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public.tb_user_type
    ADD CONSTRAINT tb_user_type_pkey PRIMARY KEY (type_id);
 H   ALTER TABLE ONLY public.tb_user_type DROP CONSTRAINT tb_user_type_pkey;
       public            db_union    false    251            w           2606    25455 #   tb_log_admin fk_log_admin_module_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.tb_log_admin
    ADD CONSTRAINT fk_log_admin_module_id FOREIGN KEY (module_id) REFERENCES public.tb_log_modules(module_id) ON UPDATE CASCADE ON DELETE RESTRICT;
 M   ALTER TABLE ONLY public.tb_log_admin DROP CONSTRAINT fk_log_admin_module_id;
       public          db_union    false    239    233    3418            x           2606    25460 %   tb_log_member fk_log_member_module_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.tb_log_member
    ADD CONSTRAINT fk_log_member_module_id FOREIGN KEY (module_id) REFERENCES public.tb_log_modules(module_id) ON UPDATE CASCADE ON DELETE RESTRICT;
 O   ALTER TABLE ONLY public.tb_log_member DROP CONSTRAINT fk_log_member_module_id;
       public          db_union    false    3418    237    239            m           2606    25465 -   tb_activity tb_activity_activity_type_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.tb_activity
    ADD CONSTRAINT tb_activity_activity_type_id_fkey FOREIGN KEY (activity_type_id) REFERENCES public.tb_activity_type(activity_type_id);
 W   ALTER TABLE ONLY public.tb_activity DROP CONSTRAINT tb_activity_activity_type_id_fkey;
       public          db_union    false    3390    215    217            n           2606    25470 '   tb_activity tb_activity_creator_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.tb_activity
    ADD CONSTRAINT tb_activity_creator_id_fkey FOREIGN KEY (creator_id) REFERENCES public.tb_user(user_id);
 Q   ALTER TABLE ONLY public.tb_activity DROP CONSTRAINT tb_activity_creator_id_fkey;
       public          db_union    false    3432    215    249            o           2606    25475 :   tb_assistance_request tb_assistance_request_member_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.tb_assistance_request
    ADD CONSTRAINT tb_assistance_request_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.tb_user(user_id);
 d   ALTER TABLE ONLY public.tb_assistance_request DROP CONSTRAINT tb_assistance_request_member_id_fkey;
       public          db_union    false    3432    219    249            p           2606    25480 :   tb_assistance_request tb_assistance_request_status_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.tb_assistance_request
    ADD CONSTRAINT tb_assistance_request_status_id_fkey FOREIGN KEY (status_id) REFERENCES public.tb_assistance_status(status_id);
 d   ALTER TABLE ONLY public.tb_assistance_request DROP CONSTRAINT tb_assistance_request_status_id_fkey;
       public          db_union    false    3396    219    223            q           2606    25485 8   tb_assistance_request tb_assistance_request_type_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.tb_assistance_request
    ADD CONSTRAINT tb_assistance_request_type_id_fkey FOREIGN KEY (type_id) REFERENCES public.tb_assistance_type(assistance_type_id);
 b   ALTER TABLE ONLY public.tb_assistance_request DROP CONSTRAINT tb_assistance_request_type_id_fkey;
       public          db_union    false    225    219    3400            r           2606    25490 =   tb_assistance_response tb_assistance_response_request_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.tb_assistance_response
    ADD CONSTRAINT tb_assistance_response_request_id_fkey FOREIGN KEY (request_id) REFERENCES public.tb_assistance_request(request_id);
 g   ALTER TABLE ONLY public.tb_assistance_response DROP CONSTRAINT tb_assistance_response_request_id_fkey;
       public          db_union    false    3392    221    219            s           2606    25495 ?   tb_assistance_response tb_assistance_response_responder_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.tb_assistance_response
    ADD CONSTRAINT tb_assistance_response_responder_id_fkey FOREIGN KEY (responder_id) REFERENCES public.tb_user(user_id);
 i   ALTER TABLE ONLY public.tb_assistance_response DROP CONSTRAINT tb_assistance_response_responder_id_fkey;
       public          db_union    false    221    249    3432            t           2606    25500 $   tb_fee_bill tb_fee_bill_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.tb_fee_bill
    ADD CONSTRAINT tb_fee_bill_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.tb_user(user_id);
 N   ALTER TABLE ONLY public.tb_fee_bill DROP CONSTRAINT tb_fee_bill_user_id_fkey;
       public          db_union    false    3432    249    227            u           2606    25505 ?   tb_invitation_codes tb_invitation_codes_created_by_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.tb_invitation_codes
    ADD CONSTRAINT tb_invitation_codes_created_by_user_id_fkey FOREIGN KEY (created_by_user_id) REFERENCES public.tb_user(user_id) ON DELETE CASCADE;
 i   ALTER TABLE ONLY public.tb_invitation_codes DROP CONSTRAINT tb_invitation_codes_created_by_user_id_fkey;
       public          db_union    false    249    231    3432            v           2606    25510 <   tb_invitation_codes tb_invitation_codes_used_by_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.tb_invitation_codes
    ADD CONSTRAINT tb_invitation_codes_used_by_user_id_fkey FOREIGN KEY (used_by_user_id) REFERENCES public.tb_user(user_id) ON DELETE SET NULL;
 f   ALTER TABLE ONLY public.tb_invitation_codes DROP CONSTRAINT tb_invitation_codes_used_by_user_id_fkey;
       public          db_union    false    231    249    3432            y           2606    25515 2   tb_member_fee_info tb_member_fee_info_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.tb_member_fee_info
    ADD CONSTRAINT tb_member_fee_info_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.tb_user(user_id) ON DELETE CASCADE;
 \   ALTER TABLE ONLY public.tb_member_fee_info DROP CONSTRAINT tb_member_fee_info_user_id_fkey;
       public          db_union    false    249    241    3432            z           2606    25520 2   tb_user_activity tb_user_activity_activity_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.tb_user_activity
    ADD CONSTRAINT tb_user_activity_activity_id_fkey FOREIGN KEY (activity_id) REFERENCES public.tb_activity(activity_id);
 \   ALTER TABLE ONLY public.tb_user_activity DROP CONSTRAINT tb_user_activity_activity_id_fkey;
       public          db_union    false    250    215    3388            {           2606    25525 .   tb_user_activity tb_user_activity_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.tb_user_activity
    ADD CONSTRAINT tb_user_activity_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.tb_user(user_id);
 X   ALTER TABLE ONLY public.tb_user_activity DROP CONSTRAINT tb_user_activity_user_id_fkey;
       public          db_union    false    249    3432    250               �   x�őK
�0���Sx��$�ָ�=@�n5��������(�����i���¥���#�&����e�(�j�.�	c�>�� qj����(���o(��s�X���H�'��%wi���J�n׻�f9m�ù���> �ؼP�,hW�(@���d��*��*�U^�y��;+�o�q���ߑҺ!WF�7��FB͒(�ị̌�e=��������	��A�3C��n���         H   x���|�cՓ]��m���kg�%��P�А��Ԍ���Ѐ����0�|:{ѓ�����2F(����b���� z+'         �   x���;ND!�kX�l`�y��X�ؘ]�۰����La3�uB�̽7�9|߁��0H8�^�Ǘ��������d�żA�,�!��
/"�*9���O���4���B�T�$e�\�#o#�܅<�Wח���Dp�[���"yi���e���������%/�̫Qn�W&���
�����kj �� ����F����g���h��|�j���T���a��6ԿM�W��],�|U�H1�k���         c   x�Uʱ�0�ت���I����H������̐l��� '-"�B}�X�-�rֈH �p��������5=��|��:��骋Z�V�݂L����mL^         >   x�3�|���麅���2�|������';�rs>ݾ����O�6s���O[7����+F��� x�         A   x�3�|�y��}����<�Zə�e���}��u����4�,�2Ep��\s���4 �ư�1b���� ���         �   x����1�N�@����
�_����r"+�?i4��+1E�b��7ц[S+�c�zF:"zSxbXo\à��
���p�E�/�v��Do@;�X�[wD�3;E��l�����+��޽B٧?�O������s�         9   x�3�43�30�|���i{ۋ-;���qq���sc5�2�44�6����� oH'�           x�m�MK1��s�W�]6�W2In"��Dz�VD�u���쇖ms{3A5�Ӷng/� ��! �@*�%j�<΂ x�_ɏ��9®<sMͭv���Ի(QR @��O��X�,���c��m��8W��Brl�c��\E<V�|^T�G`V�W����zZB~�I�u����j>=����߭�W�<�$��nb�=o��mdb<2t������Q�����F��+[t���f�g��z�����:Ϳ'���E���y[�/+q�         �  x���MKTa���|����<�y�E)Y-"��ڔ�N�$R�B��m҅ ����u�W��&���2��r���y���s��Tc�􇵃�/ͅw���G���s��3~ifbf�a���0�a�0S�$%�����OP�f�et�*F Mɨa����������Ncq�x�M�f����'�'�Xf�L�sb�yi��d}+7ʌ6�PpF�K��4���� ��*�7�t�����^N���1&�&TMμ�x2�r�
��qvdA�)�Xtu�oM�=��"�N+�>EA�&U�H��c�{��5>�8zN�������zsa�T�6%i�p�9"[����IyP�J�mHLZ6ro��ޏ���v������F.�R*6X)E}���3IKpZ|�P;�,_q�h,�}\k?�=;���(Y4!"�A?��S��:��D��zv��)H� �y˞�:����Pц��\Z:���M*����܂>դRu���o��!�wLlλ'R7�4A�"6�G C��
h�N}�cH�*J��3��<�:�&e�n���\p �U�2@?��za��!�hl i�ӷl�A�˓I�%�C5�v[�A-�X2Էd�5��7);��#�v���: R�<�c�b���D�����J���[�+�ko�K[��樓[7m���E�rV��R2\�a/קo��_R��AK��|���
��.fv�I�h�[c���         �	  x�͜Ko���䧘��D������I	�$�d�>0h���I�b#�>U3��%��C�5�\�?������'�w����\���/���^������o�!������Зû�~�����������rH2|��oߜ���f����׫�~��r����w�^�L!ڿ������f�+'�y�N�O0"���p�8�(!23�b<���{8Ͳ"��S�D!��$����`L)`�T�^\���=ͥ/D� E(�ak7�<2�UR���!�&.���"�8aN�@�=�)H&�n�SO7%��b>ROkHc�fn�9\ST��H*&� �GT���QoJ�| \ST"���z�kj�3��?ы�M?��c*�<�� ���Ia�%#���Zǰ�))׏G,�d:�ڏ�L��b.5�]�GR�P�CᘼX�Ԕ�K ��*�E�GS&BЯ��ڏ����B*�:�~Ea" p�׵As��� ���m��(�DȤ_Q�����1�F��D9;�~��=��5�C�GT1�TC̕
8�5U�	bј9Ԍ)y�NT��XUR&�8�O]��Tj����b'ҲCTL�T]b')0�*��$�(j����$�Cd%�X�C�D^fD��J��v��k�˓U�c`ҽu����1��(��d�4ISg��u�!�;��Q�D]�`	m2D����@'Q���#r��%���D]&D&�+���w���eFdS�����:	]f�le�Z��E���r|]������%;�]��Y�.�R\��X�]�c�0�}`�-��S�O��V�U0t3zB���@1�l�/.�����|�1�QD��R�-bKmy�."�X]X�-��u�Yȧ��}!����"�Ԗńhڒ�5�s�-��5�5���8ÝZj��M�1�B�M,ΉHkj�C�	�G��)3��'�5��mt1D��R�R�ssRҲ'�?
8��:�?�-�Fa��$�)-� ��0!�}^SZv��&���:%"�+̯bҢ��V����d򫸦�<<E��3x�K=h��h�GՖD�i��-{D����c��EU[x*h�(���!n�!�R�W
�L.��r}T��e�h�1���.,�5��!򔊨c� �|��z\fB���b��]��V�>�e����F'ϙ��Y\S^�0Ҕ[T7"{�Ӈ�̈����%W��Bk��cD����jw����ˌh����X�[E�D^v�	B���n�D_fF՗��N����1v�/3c1��{�>a���u�[y-2�����wū4!�Z���~&M�X�nD�ݏ�("�e��1���G_4N�#�.}�����n}���$�ꬎ�#0l���I�p��+�G`1[+�,�;d��f���?{�X�%S�h�sĥ���:]��*Y�#�T^�Ȗ��*d����Ϯ6/��<XÛ�B��دiK�Y����Jp���a��ڳQ� +( '�Q��ڳ1Y��UC����,f�0�d���R{>��e�d=��X)8��/����цg%F�����,��=ᜯ������,ET�������kj��}��QU���r����,^�d>y�X�_�N�eF4T���Q����RF�cĐbb�F�y)6�d/�P F�oә�e�X�:� Bէ��/[�	R��_t���S���.�H�����tӹ�����z�n�/e6�_�h��˨�?��3e� �uHc���g���(LI,wVY���n$F���P�d�V4�_��S+k:Z�5%�����PV:jDi:��
DUQ8�8���ҝ6D��޷�C��V�4��bԍv�����U�%��S}_u�1�e�4Mx�W4NM>��t�)�Y D藱��)���R||�t�c��B�AKqՙ�����iH9D���M�_nw����9�͢_�i:���e�#Z\��Ħ���J���Գu�}D0[�i�Rb�y}>��t�1�X��>�:��D�b�2YFR���H�!L����!��ZQ��@��U�!���aӁ�e��޲�h-ze���tus��}ȋ!��Z{鄶=[�Ϯ.ۺ��g���[	��K&��]k� 3�!grF����S�V��Auĉ�G�D{p����KM���!N5�DA��\��l:���ψ4�_X�x�N�g�XC�)pgכN�/�h�
�U��������?mn�>�|6�����f���?�)�@?�1�z,AC:~U����֘0��������-��u�1�~��QgK`D�J~a��W���~6������\*�������w?nn��Z�w���4�;fh�fQ[�ʝ��A����`0M9t�	Wp�����������N���t�g\;6%��rȅ�GHM�X�(V�C,��Bl�j�2����wj"��%W�Ǧo�ڛ�����E�P��k�&���K�Qvl���Kϭl�A�9P�ul���+I����n�Ԧ�,`�ҧB92�$S�G^A�*�����O��=b�܃ʼ���FNOO�����      !   3  x���͎A����t��?���^|fc��č�����e�z��Q��a<�
VO��8�� d�_��SU��������M5���.����y5��Ûjx]�>�'��>�>��>j�\�u��=�/��N��c�ߑ	R$P��d)�U`�����'#(h�+���,I���ѳ���r�y5����ms�*͌l3�{Jt"aI���ِ%:���sт���sp���-�F囫�b��_�'W����^�&���E)�M�(��Z�E�#�7��$G� �'׼�?L�a4�D�7CD�<�`�ͅ]3��/V_nE�u:Z~�^����o��\ލ}h�h�鐚���N9���� X��ڭ��z�!nc�i+}�,�[���b�v�d�d|���u�Y��q<�K��ʱ�E�0}��%��H�P?�=��p��I�^�z�&�v�8�=�냮��7��jW7�|cI_��w�n��}��{�� h�9[��Mb�ӈY���m�,�`)P�EfG��az#Yl�,7���f������q��N@��w˒�;ɒj���z ���      #   =   x�2 ��1	活动
2	援助
3	管理
4	会费
5	通知
\.


���      %      x������ � �      '      x���v�F�-�~޺<Y�����v�]���W�^�����Ip�R2�t~������� AI�D�"yx�U/@"3.3f̈���l���~Yl�a���l�/��q?˷���*E��p��w6{\n���"���l��-��><��]x��}x�Op�_?��/�>}U<��Sq�ϝ��� ����9�>����p�˷�j�W��#�l����!��������c�is*69\K.�}�ɿ�%��9���/���i�x:,���O�d_����Tl�����{\��2����Ol	��8��gW����f��޵X��V�lu�/��EXl�|^�	��5�������s�놳bs�����1�u���w���<,¿�o�K�1�X�|�>?��E�/�im3xiq�����M��.��継������?��sY���Um�
�Ïv��`�`K�w��o~9_޳�<��Uv��X��ˏ���_���v>o��m7�q�9��n��|���.���v[����'��no?��]|(^!\<�{��pU<<�C�[�;.���Uq��������{��{+,	��j��p�_�s�	pS���/��~{��=�.��O�3_����_���x�e�?�&�台O���w�![����%����w��a����;�xZ��P��%���3��*��Y
����>�7�]�&���Vnv�c��;5�bg|��GĖ贙-vp�O��|������{��#
�2�f���p|�lɞ\�O�G���I�I�ŀܣ	��;��.��3�;��`q�O����e���g��پ�k��l�%�����`I�zQ�%a�O�QM�8t���,�4��~�!z��_���l��;x-|�.��9��Oy��)�}�����?�������7O�߰�������p����a1�ٽf���[!���8�?��[90��O�|X��]������]xOp`��f�7_�����4h܎��Źrw��x ���%����g�gq͜�~_̖zh�����<~\�v����`�l��*�C`_���7������^|l7���p]�L��\	�tK�x}3�q�/7| x(��{�k�Y�㎭�]/\�,|(
��}pׇ݉I�"=-N�P�;��_�bϳ��՗����������<��Qy�����������wX׌;7�L���;n2�W��\-��/�_�M��N���m��5!+�/\���ƻ�8��v�D��q�4ß������S��;0/����Ο���RY��]i���������� �_�߷��Nf5�g�^�1̙NO[��V���W�z�*N>�u���N[���w��M��&?�)ݝ��^�w>�Uo����v�v�.�W�?o�8�g����~� �\�U~��%���� ����ȓ 0ػ��%X���/�l/+V���c�d�X��e�q#������ؾ��\֑/���z9<l�$�5.������-�Ֆ_6�!0b`<z��g�)����@<(�)��/��`�2xx �!n�]���r����D�Y��*���
��0�>_�Yx{�c��7tp�N�#���em�/��4��;C��W�rQ�U��Bv~VX�/`�0�\nD�3Ӑ��_�b��o�d�؁�k}�?����SŅW�t%(��}>�:����i��F��5�4���������*`��Pؑ"B ����[�o���'�H~��?|�3tQ�o�Y��&����U�9;�`x�x��30���r���}���]����)\�`sg���0
����q/�	�a:�� ��~�<7���{0{p+�l�HWh&��⚿�{u8��W�G�]d�-���C�z·!����oD���ۏ���幬QWD��AD�`J=/X�P�:����Ǐ˻]��b��-gv{a�|����c�~������_\7^��3xI�[#�9p��e�C[��Рz&1�(���C����gk���s̏� ���F|�+���������]���
b�Ǣ4<)b���X:'�+|�Wl{-r��!d�)�#�\��o�m��}�T�7��Op:�*��̼~��rx>{�4���`x,�aܝ߉^��Hf�+�R>�Q�ϛ�� ��[��� %w<6��	W�ݢk*��p�AĹ(��,�h����]W�e��q.v��|�����D< �¾��{��7�����D)?�2p�����`߳����!�{�Lw7�	<|��7�_���=��2t`I�c�P��ɞ_�xt��9C~�/���"�xp�O��6̋��<��JJƭ|5@�x��T];���$�X�`ߊ$��u=�kvr�!��+S�o�8BL^�٫�<,�"���L��[��th�1�E�	�?^<[��^<��CEk�������w��nfo�"c�N��HW�~rrXڹH�����BVn,�����>��P�� }X��믿*��=�����I�K@!	�+?q^`�j���Z�p�qPc�="�Q5��{W\>K�����pa����f���X��*�+v��f��o0+��|� |�A	��F�-BD,�ĵS��L\���)�4�����`"�cv�w ��J���b`�.���K��������9�)�g<D�,*�d ����y�Ek]�
�e��o�?cK�y9�;|+<P��2�s����9ãxl���n^�o�rt��3g	�#��\���xG�3b)���Ο}
$V'����I˃��b������f{=������7C���?1�I�t�镙,/��0��/�Xav=lݯ�m^���3�����n�,���*�Q�)��s8,.��h��{Y��60���ey��p���9�+��\�َ
+�`�χ�[�xR�,�=F�`ѿ���3�n�O�(�=d�|e�����pc��3f�"ڽ���׷�����uip��öK󷋥a�!�B��◆X�Q veЅw�%|x|��%jٵ}���Ɠ����Џ�d"�|_TtU�3�'�z�L���k[F�|�X�C@w	G�ϫ���<A��xz_	 ���[�y� Sq|X������� X[[t9���a	��6�-�3���;�ac�%.'ر{=��=	��C���b1�dԋ��d�Q:�Q�Q��c[T��X�`�������� �͜[�����9�c�G�?{=�=$0�{pE�;�r�	�?s���cP�ļ��m��
!>?�ÕC�� �X�������0����Q�x�]Q<�)g��~�-T>��q3�)�·�.������X�ɾ���<�.�+"]���H;r	�9�̨|��h��܄�M:���TA�D����3� _�e�å4y�FY��4��3��?�[�x��^�a��g�c�-Z��L2��_���!x���7�6���B,�H�J[>�I�r%bh0#{����FU��+���p_�%ĵa���J{��kڂ��l
��'�s�|ϐ��<�����\�D�jlx�G,�at�z �/�u�.��s��:F�Ǎx	�>Oy����)���i�����_0�����d�����@�ΣRV-�_#�Sz8��ލ�$J�Q:H �w��� �������'V�
��A���o�C�Y�����v�� �9���^c@Y�9�&�Խ�s����`2�7����Ʌ羚7e��⪚N�n��t�y�� �"�@�� ��+�?w���w7��6톿��c7���E���,G���r���#�������}���.;;����v2�@�}�R$��$Y�M�nH�J%�z�m*!0���g�k�P���
���-W%�ٶe��qA����-�uVb|���w(z��"��f)UY�2�9/E��7�}�$<�O���v�2���ι�!�~�7�D��/�2�xZp�ѳ�X>s������y�\�3���<6H�g�U)�kD��=|?�ň��?��Y]�`�+�%օpIu����X,u�7    ~���Ƭ��_�+䃗���+;\��3��vX�,�s����Ze�V�3�/5
��NX�����Ұ' �-c���.�E6]��JI[�m�VB�&�Y����r�P]��/V�S��/e����33����ۗe����da �`�L��8�'�p��MgH$���!�����6h/�׃G��0XjTl"��n�1���ǎ ��N�:���
���72�]>ܔ_����5�Ց�;X��d�\xλ���<ӥ�u�I]nz�9Sb3����?�ozK�+��3bVB��3^/�נ��P�5�����j��j��Q��X&�
��,�Z�1���$����=ϱ�����p���&���mǻB�%�Gx�,o,8�������)M �?�r[�yH�U����)~ʑ$�n�uʜ���C	�nm��E+0Ī�-��ƞo�����f��v�N��CO��f�a��g��ñ���f;�p�~�-�������%����:9(�8�?�5���]y^�=Ӣ��qo�e{�����G�L�x-F�zD�{뾸?<��P�Ǆ)Q��W]�%�ʁ�m$�W��'t��5��,z��a%$����Υc�0�`����S%|��Ǯ� 4+�u���H{Q�B8]:�Ns��<B�Q��Fa��Q?��x��2rbW��+���tu�$Z��~]�:i���8< '�������I�z�#��/�>�U��K����<n��<�힭N����6�+��2�8n�h;�F�M��+�_(��^��8��4��Mg����2��Tq�a�6�S��O^�"5ޥY������n��e�߽[��&�2_�q�Ԃ;鮀o������lr�S"gn ����mK�.W�r�ꪅz��70?�2 x�>��T���{Y*��B�g�(�0)l��A��P�O�)hX��ը��m,y/�ϭu��,I�2*n	M�Dvc��Q�rDB���@do9FӞ�_���IMz�o�� ��i<�hԹ	Lj�˷S��>�
N��3�H��u ��Y���lq��w�mt��_��d�y�rË;�lb��8oUZ��n6MA�λ�B"128�J=Q(9�{�8��i��H�3�a<�Z��+W/'��Ǿ��Q�h �j��}Ҏ4��Nvb���XX�����.>50ŗ�sk�s��fJ���a��|�� t��"�*�:_��|Zغ�PaJfޖ��u��W|��z�$;�⼺�D�c��h|�w��x��f��O����e,�m��&V�+V�D�5vJ���"uC�NȌ2�U��P�ĉ?������%Y�B¾"gs���fQcK�<_-��t����qW첒���n�CQ<�����lW��D�鏣��>��6f��(��w����Y�I��?]H��R0��?��̸���\�!����?��3��<[�%������6C��͈k+,�F�t������8A��g\d����9w�����P�T�
��{���o-�B������Y�x`-�좱����M��
��������uM9�Q�3ke����z1j��l�l}�HC��!�T����`l�	�����co�pBl��N���#�~Ȅ��a��(�(�6H�\7X*n	v��Ά�E�`��nd�9��jew*{���=����
��Z��2Ｊ��?c��h�}�ƺ��<���@<'�����'8�Y�}x��˕�R R�����).Ż�}���	���3�D�m��ɞ]#Б���@�\7��<t��_A�Y�6�ٕ�M
��� $m�!�JŌ�y��VS3�<��V[�)��.���N4LzQ�߄� ��A$q'��t&xg��54cO�	����Ӎ��(���&-��H��fҎP�\�K"��4�I���8�/��J{#�)"��""�\��T�m.��U�aHV	v��֊�I~�_o�*�=�w���.q�X�&�D/7�h���';m�x܋!ˆ�&���o'�8	��-X7.M�6z��V���$�o��&�=ӹ�æ�>�x>�T:i���uPm�P��Y�R�Y��.����x҇��r��emn��[1��2	�����_�A>7g��\*����W^��Z!��մSw��+�츷�wX��?gT��\�^��ˋƷ����\�*���H���y�x�^����d�k�v~�c�<�$��|�J��1*+��L�a������X��ǈ��ȥM��x�)��1�}܊ZU�&�<��Ŏ�@��m��A� �����,������	U����WS�����!�&�tx�n�8�w�~�"]mI�׸6��=��N?��)/��!؄��Z2GV)y��f�,XpJ�M"�eo�f�'"��K(�Li�r��u�8��No�֦U��X;5V7 �,�K0F�:�Ț
Y�\\Z�,$�h�$��`�v.���Z��+VD�L��.���NU9=�M&a����Ɲx�fO�Y���oT��rjʹ�<��-c�h��Sk!�D�Ek�Z/_j�tk���^A���ꦅ��~.��qě�.�C�(�/������&�?}�b~x"1_�J���M9��?��#��uEΔ��oo��N�v��~��~���U��q�*��c#-���,v���;�U����j�KG,�r���#k'��Z��*o.��e��dY-��.����O�fʊ<[��.�]-G���-�ټr��9��|q[��1T�˞���(����xS18Ü\���h����<��VD�ȡ��B�7��Ӛ0�]vV`�I46���
-Թ�t�DI܋�^�G�I��� i��@k�د��#���VAٓ;kl����Nd
�&��ZH 'RG�w���g-�i !�@{�w�;.~
2��cW����0x�M
^�.I6��JC��u����{���x#�\R0�����㊫W���j��lz�^�UZ�����1�:���ૡ�$h^�ڗ���Y�6�-ߞ���Eg���:���m�{��F)^w� �mH;[{��D�J8�W!#�O��b;Ȅ�E�ق-� ���:Ia��v-u��������B�;���U��;������< ���ϛ��~�Idq�4�讝�u��wA?x���mf�n�6Yӡ<�d�PUŔ/#����=VN%?��;X�����l����Z�ɫ����# ��ǣ��q�/h�zQҋG���1�������8��$=J4 � ���Z_�Q��+B�Oc7���j��~9��q�C˸�Bmˁ[׎�/�����:K�11�9�?f9� \�S���e@zx����Y]�;�n3oZ`��p[-O^�O�sAs���D�d[(� ���TN1_~{NDXby��?nʫ��?�����$�.y]��ժ�C����R�d� ;���O��L>��e����q;-�MR�i$��dJ:ސ2-����MΥ| �%5%�=XC�x�1F�lX�z �ѴՌaz7�n���Mxpy(�L6Q��
��	o1Ʌ�",�s�WN���)p9��-r K�'�E��os�0=9|U�VC��og�w��w�.ӈl��5'�^4��Ls"駃$����ϵC�#�^(un�v���lr��y����}�)=ʤd�L.R�k�h�%"��K��Ih���9��8�W�{"[T��1@eF_j��4{�j�W�1>�����rh*�=��5��T��&�E��F��A��
�	ir��~/���8��i�M'���a��xT��{-IM�� >��$33>[�T�[���C:�a�4E��F�B�q(?��eE��QmÇP�"5yIF����}��u���A	�wiY����xՎb�C�\����2��=wI�_��u	0*ݩ�c/S`2�=M�!�AJa� ��m�S���S�[�}�����~�6�n�cP���%l�q�j}_T��XQ�����r����3�.�Vi�U��Fh�-����	�y�]�A�7C���9��p��f�(�Y�RR}O��eμ��`���r�v��rh�    �Z	���S�S����Q/¿C�� �8u��P�P@��nAېb���;�n����W��v�����Å�F����������e���`�}?o,kM��(	�~9�_A��M!�qr�	v=�!����;������w�#IL4�,�H	|;�#{k�RER��{��Nc��񠒵F�J�nl��U��0��I�����(��r�
~FY%����=Gd-.8�����.۝v��aqљu˒o���k�40����m*�B ��?��oΤ��a��(.��Y/�j����U054+?���zΰ,�X:.n��_�x��������/�_���A˂�(/z'@�I/�Q��o�x��3��D��Lƅ]/�n�=�l�f�l���%rB��J��c ]>i<��]oʛ�(	��Nu.�������T�n�8I�(��yv��XѢ�Ԧ���F��KA���H�Ж�z]���c�O�nFvs�;̩ҖD��:>���>��z���$dch:F>M<!.�',Ռ�N�����p�v���kT�M�q�1{�܍)I��m)�0;��M�Nl߂�������9���w9\����w9I!���m�|����k�G4f%L5JA8�5(!%:m �ኴ����<��I/�{�$�i�1"�I'I���w?S�2Ep�����i�{�NO1.��VQq^t���΋N�/4�4t���c7�}e�`؄�I�i�%|��OV�����DFJNI�UHJK�JFY���vW��y��+�������Cx�
��w���h��|��q���
&8��J�/*��l��'����Ѵ�0�^�b�m�ˍ}��	eS�CO��qU=<	��h�BN>V��Y&V~`ʊ�&G�J���U	�� _֠����%3�ߋ�a���8�O�8��$�@{��7��Hb��.����r�Ί���e]��3_��vh�e�^��FF�=�\n]u9�U�X��!�F-�!Y�nZ�R%��"YK�Y|��`$��k�Ƞ�f�&x�[��v0�[r�M�1�C�Ry�q�HXb�R�(� �y�K�a<J�8��720=�7,�&?��A�7��c�/7��q1��e;x�(w7��}|-)�d��RH�-�=�ƙv�K����$3�&`��c-���#��;hh����1|(؍��-�~���e�ߪسW��\�s��k�8޺��ّMv���iӚ"n�^]q�{Ik��Jԭ�:!C�C�Κ~\ʀg���X���6�k�n�<���S�E���5�&ɧpz3���8�IS.���QB�>���J��򄥎F�Y��OG�}�T�dFCiDA�t�Q`"+�_�p-�dd��W��tƋ�=v#];k�`(��t��؎�R/k4P��[k�.��X�V
3һv��Nz�˾��5\�չ�i�����I��s���,_GGA�r�{�2w=�����l�g#��l�)�*B#�.p^�$��Ӹ��'c]<��v�����(�АR�W�S�W��4'�Q��x��2��b��d)�j��_APN9hT��.��R��+�nJTN��J�m���'o�P����)*�&��Q�����.�]�*�����BU	]��	T��y��xAV�T$M�\�Ҏ*�ȴt��ζ2��[X��:c�2����IM�_~�I��YK�}�1�;b;7m�|�P�+�i����qO�x�I&��pC`�0���.M����t�9��82�fʑ���F�TGCrG)h�Dy�&k�h���w�л>���S�X�v�@R$Fy�;u�U�����w�O��R����~-Eز�u���K�ϯ��4����Ҙ�[�JUKGJ��X�~,��&)��n�uQ��i�|>��p�b��W~��G�>ÿ���f��o�t�b���f��.y���
u�}���zq�KFXN�~`�����4ϛ�%�-uS��
���+��H~q�rv\��/w���B�T��wE�n��/<�|��/���{��xx�����#m���Q;\�S._ФJ%�P��Ga&�50�vJ�-�Rȴ�ޝ$�ۄZm��H.��*j1�f�=A��bKH��L�P��L��`TWD�y-Ԥ+  ��!+h�3�r��˛�ݔL�S�ɫC|wuDS��F62	v�� �������W<��GW�BI�F3!��/�/W|hJ/��b�.�h�NGJE����ɓ�LR�������� gw5+��g�m1���X��.�TV�#V� j�Xܛ�.�pѩۯ%P0IhGd�/C/�S�K�f÷�6y;4�GGa�G��5'��00@�Y} V��l�"�q��CN&r�q��;������������@	�J� F�W 9�����8pi�-xB�i�e�Z���bWx�h��"v ���?�tb���9�w��7D��Z#F�9��Ń�R)Q��#�Ů�9�Jd$zte{n�'GS��hG�~���[v*�������91{e�E�5��g�5���9�Y���4���V;̕�q��5�/_ʻT�F�hz�³[2��N�� ��K��e� [sŴ6����w�s����� ��\Yr�j&)��w�"k������_�_��8'V�����-�w>+K��\ñ�O�B����|�㫮��2��pU���29����|$,�A�{A�/�!3��Ӆ�B{]O4%�7�O����eJ6�����A�$9�Y��u�ԋV����/�@��!�S/O�a���+�W D,Y*���H���;�a0rs�u���`f����T�WI����6��ʛQ�%�P�lP���	h���n��m-���
�`������r�T��y�b^rܖ��9�?64����l���rY`���/�]$d����;l�FI�;�Q������i���l�TC��2#��Rޔ�ng��&G��1�qU��%�P���~�2[Q��e�<hv�uMJ[� �C�{̕Mv�K�=kU6E~���$u.j�ʢ$N�ו(����"��G�OQTl|~�F5n�G��J��H]��rF��u��|����v{���Xf�Ef������6��4+��O�$���"�w�����_,g��}���`��gԦAA��g{�����ڰN*M�)��ƅ+/���9ˀΐv�*����{�-Q@�:����X����VȰu�fa3n�����ɢo��o�iMnk$8�5i�R�i���k�`g�%����8b��AE�����h�&7�p��c;��ą�
��qNc(��-H�+���5�.���P�&�'� � ë#I�A�[ �	��Y^qT�sg��k`r���חy��N���2|u([u��P�y�� 7�ܣ��}���'k���w7��6톿�9�w�|_����X�!���e�'C��u�B�	�4���MCL�O�������/�[WyL=�n����oӮ�E(_�YJξ��I�8��Zt忘>��_��5*v	�׭�"�k���K��6��e#䓓��L�%�X�tI��<`̹��5�.�����(�6����h3��ea��.ϺĽǾVD]�X���G�L�fۓ�6�h��oXa�0w�w���\����RkC�!J��-_lGB�1|��)3/y�|����ܔ����|Z,@9��2���8���_U���S>��N��� �S~W~"zS.AsG��ͪ�q�����#����`v�*���9�,IM��L�`���ފ��'.��>��5��]�˹.Y�K�-���9�ɫ�~�<�е��z9���Yb��g9G�H�.1��h~�A�G5�s��.�q��q��w���|)�5Y�f00҈#����ד�6+�L�D'q���w�+�#,��	�T�a�Ӹ�����W�qD�2��h�� �d�H���'vn��Ek��2�%c���}Y��hU���/��ɧ��qBwqv���{����QX8��x���a��ly���{��p�|�>A2��R�J��'&�rα��m�Ѩ�OP9fzw)�^ �z�I���<��-k�    ����Vj���]L��Y�s��f�s���B��4}븺�r �u��/���TZ�1<�p�K���V������\�Ej���_l*�(؉Җ�\��YRo*������$?�X��:�J�.�2�Gp�5,��qSjò����e�+�H���7EN!������[����8�"R��(M��Nx�!i�O{��d�|*M-�[[����]\��\�'e�4Y����w��F�P5����w���W�7m�����sCAy!I�!�;a1C=d=�A�%�$饮�
	���Lh���1R?s��n8��B�
T�Q�9�,��ך$��^��H�Et���y����4Q�P�;�a��ُG����`z<N�Q�q�t�###i_�u�WgI�?��e��"�rr�ٴtD,T,�;G�(G�� PS��j�fV)��\�U!wo�Qt:���uG������2�$�����F�vn��峺th���%X�ձ3GIv3�����*���&�8I N�C1�?�� �{�5:Hy��9g��\������V��!���5��C������ �0��wX�UoG���JԘ����ޣ������E���ݝ�`V��\:�!-�E��$S`� ���6��	s�l2#���S�}h��O~e�����K�b�t1,�dU^�į����(.+:ȵ��ӳ'��o˶Ӟ��3�7W�l���|� �܈\�q5�x�\�׎�%Yb rҋ�<�Q�Ѱӟ&�?^p�\�<5EC$\�eEeV	��B�t��Kg�$+5m����S)�Y4CG^v+�)�s{��QEi?N�Q'��M` �{��ny�&2V0Y
Y��������`�9{��~uı<b!6�<<8���A��Ҍ[���@�{��l�E!�o�Ky%�23�a��&�Eck��VH�;�bsRa����Sf�%i�;X�=P��W�g��',����@��zbV��@U�8��Z
�+SȊ�h��41,�(�<_��$�nR�6VS{�/=E�`��<�������C��]�9���e��V#re��%yS���O5j�I�<�_������ܲ>�1��e����8�SȮQ��x~hBr���me;���h@�4�'1�%�K�qBi�����m	�tK�T���'t袼/��l�"Ip�zfE���`wI�D�(�%	�&���:�8�>|DR	�L�F45�H)��.��=gI��iE�V'�r�퓶�!:�F�����0��HeH(���w"D�^?
�A�Di<����$�����O��<3�U��!�\8����]� �`b�g�癰��$���\�.:/���������sV�ڧ�.0��NY���F��u�sju��� .[I�.l��jPJVو�!�b�`�R��Y��4Zү��K���t9d�s����66+[��>��L��!}X��믿*c�{<K�'�W|x�S~W~"�D傍CP�0���j��U���&�{�ɔn|RDHmҋ�8�+���0	�Ig�W�<Bql U��C=���ϸ�@-�%훛jB@E��\�=�1򡯼}թ�t��^���8X�*/�j�y�-(�V�fj�	iO���JU���{��/��X/~���ǹ���?�2H808�{6YI�>��~���WI��{q�^�1��BzȐ�=cxu�]���r��SN<F5x@-ɥ�Sc�z[;"����HBv�N�,�ضPyz�F�'���{��O;N�kH��������[7�z��,ӅԘ-ӈ��[RY�C���5���O�wA��I��{��E���.�!y�L��k!��cv�w���x��x���S�h1+N��y�T�'�/'��I���$��^@�X�cKH��a:�Q?��ag0y}��b��t�v5WLv٪��!��0�u��*tYޜvs�CY��w$�.��/��zq�דU�XI)�#��#|�Es�zn:ib���T�����R�!��/Y������٫��L�,��tB������\V���Kw�Q��?��e��߱���~�_�~��XA���2�B���,�� �h@P��H4s��}�=|�;*e$�e	R�>��N��r�ϑ0Z�̪W�9�
n�>�����^��|"��wT��9��.�#*y��*i�{�lZ]���}@�`%䋼��M
�*�HR7E^������ �2�+�ے
��qa�
����K���CV��Uof��U��r��lw�r=�GO�;=,���1��9�Ս�FK��+�tM�&������X�y�h�+��Yi=�6йj�1��P6/�0�^��B-!�g4&���zLuo�d�^�\j���놇Ib��ud�o�|o���
N�NpC4�I:�0E���3�{��?�-ʄ��U:m��]mn��Ϻ��{����G�NK'�]��E� I�Qk�Q?��x�Ig�P+q׏���켡��I��Iʹt<�טPZ{��b��ht���ls��S��:���s��-���S"���Li4p��>�&@9Mk: ��UZ���v��A��1�o��d�SN���X�,G�|����\�C�z�.��ZN?���i�S����$����a�����v^� ��W�e�ڽp�R|����Z���O���e��"x7̋ b����`�ґ�fR�z��K���_�x�ނ��WP�\�
�D�8�%�0��$DA�:�$�H����9��g/��q�b�8o���s�Y0b>WP0�bŀ{aG� ��⭆eJM��X+����+ܩMx�P��V}^g}vU�	�A-���u�jM�:v�~Y����#Uo�RU�W�	��`�XqjOK�Ir��Jip�TM�X�A>��4�Ifuhk^eP-#d�ױ?�.y��Ƥ�$��7�j�]�b��ub���Z�udb�N�ǻ3�'b��X1>x�����&��Qg��U�*H�������]:�����w[�~g
�ѩ;&��ʕ.�5ҷG:�!l�`)]X�9��1~:-K_W���D}{���p�۴��ӏ��o��d�^)��c�D�z�c���=eVJT�0x5�l._��3�,�Rp�Q�#C2��>V��	�t� bp6���?N�A�;�A ���6�='�H;#�	�}1�^E�2SRU&��餶r����N���	JEEô��8��Ig8d��%�^Y"�v,i�҄�b���q�BK��Ϟ��ct0��bR�M/��8N�(���8w���Ė�I���pZ0��x$��������K��\Ă7��v)����Qԡr�ƐI���2A�� 6gJD*�gJ]	��2W
@&Ԣ��6YG��Cv.�tſ���V��#�dQہ-56Xm��#\�R?x�{���L
��$���[fM��J���u�u'vB�wXyu�Qk�02��E��M������IÒ�:�HV������P"/I�{�9gW�+�sw䫀�Q]��xD��h̝�<�Y�ڕZ�x#!%BX�Qp�����+�=\��TOO�\�^��E	�P �"��Ig8d���e��%�R:�2-�����KW�m�3�6zLH,�.5$C��+U�٘#ΆQ
;��~+��U/�P0��'����B�?�>t�>l�w�_ӹ%��A�m�0��O�]��6{���/C�~5�]���5��A2�yN�*�j���FʚES_�]lJ�^9��N�yKe����LuX�(�@�0,k�N��j���jP��Sڈ.�89~�a�K�g�ʕ1�u�I@�����e��k��QB܄�h w�޳, ��&�
��V�E^Q�$��&�!H��E�^��Ntꏂ8�;�I`������U��8���O,I:1�����8�T&#��={��ǽ��C8�i%R���M �O�3����k��9�-�D����2<s۱���2�x÷�}gWU��J�^o����<��$g�C=�P�B��w��+�,#p!�1��qEì�� �NF��J�d�KǢ���+�}"�C �⯄2��Y�5�����!�tkM����u�*dR��b���׀���Tr��gt-�g��/%����dd�$�a��    9���c!e�2��J��C]d��I��w��ɺ��M�w2��$�L���	[���n�"���^`I�����5�*��X�.7�����R��][��NY�s.�]���;��y�VBa����"�g�9r[[�:�0�L��H���#��Ч#��x�r#�q�L���Qh�i����6�S��XEg��T?*�KSփuWz�z$� t��J���Cڔc|�1Pl�U�'$e�B鐈��B�w���<���l��a��fB�KJ�#���]!�,1������-6&��H�b��D�F}G��,Fs �Zʮ�H����0��7Ԑ�6����:H�f|�+�(s�-��^�㧴e�|��.�,ѬiִcI�߀^�����@[��m+��O=����X�s6�b���S�^4�E_��iquFq`h��usw]����`�A�u�n$�w;nuF���tЇ�>�C�G��v�$pj�t�c~��J^M]�o��{qԋ�a���I:��&�����2^����`�X�.)���M)�f�D��5>��+*�d�3�:
d���$��cC5&iN�)J=�N��w��b��hSl0�Y-+�
_��HKvp�+.�.�t.���ey���m��rj�:��^����H2]�� ���2N����K�[m,��ӵ��E��҃n*��zc13_�
�'=Ԡ��x�&�7��Ig4$��Z ���R�eɍ�t������	�&��w~��
��c�w��Sv@��c��Xd� s1�Au3n������鮋P�ĭ�8u�%'I���<c<����biWmy�(+F^W���J
��\�3�3�p�%�M�w��W|�����z�s��k��Co�"6�����a�cq}8d��x�c-�Ws�9В��g�NN:ݵM'#_ˎ�R��,/�|�B�� ʧ�USr>d륟Բ+N���6_c,���g���������2T�t�[F��KUj���q���f#���-Q5G�KN��C�əut��v%����%��$-��y�Ѡ�a|���t8�h��SL���wc4$�+M�jҖ D884�\2�z2º��Z���$f���*�*D��]S�إLh7R�sL���5m�7�#���2@���e;��X=u�`�X1d��-ƺ�N
�<	/���"qj�U��r���A�C1^mI\��RCJ�'�Ψ#��F�MskB��2�������G���UX�!cZ,���Yu�+�10�3���\Q��J�	� ���+OFP�� ���p5�I��zS�tC����^u���m1�몔�ԑ�f=�.�R�R��8�K�^4�E	��%I��Aǝ�8h&��du_�����`���j�N�~%��g���!�}\n��:�e!��i��Z���t�˦�y�䮦V�N�4q�~�.g�|��y��XE��)\�g�N�L�1c�[�)c���U�J���f�r�N��>RLR�Gyl�Z����N��X�Y�*�t�{yN�k��?���P8�Z<g�y<(�������#R����/+��'���\`�u�52�ƞD�U*�R,~PWd�0h'1<zQ�0�z0�Q��ZuT�1��;ٓ����I�Dl
� ��4��qG��hR{�������u�͢~�GL"����@�#�����7:�P��.�-�m�qZG���8Z�,�V	%�X3S񡆮�Mf���������0z)�ɓ�LU2���eV���'��4J�taH.05�*��R�o@>K�.Hg��X�>������>�Q�����I"�!W��j��ZH��j�9������R/�Qe[�-�V�oԶ�l#y#�U��lR���S�1(�(_��9��~>�� ����8��Q���&�FAG�q��z��@�(���k���n6�i��%ӏn�r��`��a"�ʛ����!��&��'�U�J["��:�$�J̧d�~���9|�1�=�;=[�>�!���j�������R����QCä}lM���H*�7Pz��&U�fъgj�>|׋��V QZk"�d���
l9�����P W�HzL��ʲD���#4�o���$*�҃�O]���F~�%��!4�=�p��+>�<���!�$Lh�i�$.B:"U�hВNI�ff}��[��ƇD!7�h�K&a<N�(M� �n:��(Y��x����QeX��U��QI�]Wq��ë6�T]\o3,H+���0I��Eq/�q?�G�` ^m�'��
O���T��0?�D$�e4�Jj�R�o���6�W��j����>�I/�	��q:�]�:�~`F����C�3�ځH4��p��d	B�K�jPD��f7�.��3hM+��>z�z��jh����^���J"{~rN���js�Œ�
��;s8JP��"��	�V���|�PMĭL��r\�u	f��Q�UQm�Z��>m�	V�/CўTK��6#����*<mf��g�uH���i�|tyzw\1;f��(���F#(���4?��"�^��8aj�.�ܟKW��]p�� %��f���bl��xy�']+�W�X6�4�v����28�hh�P|�Nlbj"�3����h*�Pi26�d��)��:iF�����2��U��z/_$�4�{t�'e�un6�[���di�b�zي�tw����ɱп�a/��q�Ҥ�F� ������q���(���Dza,s��0���1$��^��46ѫ{il��j�K�L#�h�+{j���ED%��*%0��TN��f��L����48��c�%�����dξ�9Ƹ<T�C�y��������V���^����b���{ИTЫ��]���N5UU�j�U�r%V,���t�S2�Ȃq�G�y#�d�t�ix�96��=}V^�x��g���ȳu��4��0A��;.�.9��j��<���k�W��
��Ym%]y4ԍ`���ƅ�¬/.�	�(D߄�(L�%[��x�.B��Ǒ�
u	i�ri�E̹�uz��W�3��9O�
�`?�4���^�ܞ߃�!�]n����JW'�z����r�f"O�i�@,�4D�_5Y��0�?����`�Z��ԓ��=�.*7sH�0�3��&���N|���8�m�����ˬ��߇�k����u��i��5P.�y��j����)�&m4�lӞ������C��x����{�
YV��9Q�c+���{Ѱ%a�� DA'��(0P�y�O@� N;�tE7Q;��;�L�45�{���d��e<�1��K���uH��i�Y3'�n��э�o�+��.��A��W�y+J�U���`��ui$a!�?��U�g����8��~M;׶u��}�q�k��7��0���eA�c�pM��k2�SAQ6�C��7�����n��J=�i�]�᪛rɗ&�Wjl�D��cR/G���=����p&�K�J��ӂ[�ӊ+a�Щ�G�Y���X�/��D0WuDP���UvW�.%/����a�}��n%���mo� Q�֡��
���w��8;u\#�Uް*f&x�](��.������HN���"Z�ѫ[Jq���#�Q���"�x�eA��K�XbDg����̘����0�������9��p�����]az|g�f�7���]:!�k��_!�%Q<���dF��?J�~ǃ�x�B}��ߎЇj7�Y��Y��(��i2d!�'�1!��3��i)�UF�T�z��Bz�a����ѐK���%����)x�[��'�4�u�*l�p�zn�A>k7U�ҚM+�j�����X��C�=�㾆5���S�?���<q������.wӋ�at)�լ��A�}���ܽY
��R�Ldm�i�<�ّ	��s�p��u�C��K�;f�ΩbY��q'��f�AxC���_�Ԟ�W��*�/��V9߀x��=0��z\!y�鱪x�Q�{��Ɔ4!�%>��:�˖�����į o�#�+�(����,);ș��N����2���.L ���A!GW
j�:����p!MJ.Y�V��ii�T�L��p��0I�� ���M�=�x��b��c�S��    ���̠�������R�P.�kE��mC�����wn?@X��χ~��1?��cQ;<���r��KN�*���/cS츶J�7:����#�&Z8 ��0�e�U�H>�/���^-���%��2߽�x3�/����i�$pl�8�
��{���Á�X�<v�s��ll����ܧ�Z�LS������k�Ⱥs�O�,*?�n�Kq����0��)ʪ��.�Q^a$p�6����_b��Dilj�Z�����M�W���WU�91?����<�����=]r�+�"�\_��C~4V�g��C��P�_������u����/K������
�K�c�sl���Q/���8L�4���8�:�(�K�|�2Ud���P�.��Ƌ�d�v��N���`Fd��̈́�����~�
�L�%��.��tة�{�@B�M��O��fP6]:��P4q�%�5�s�E��o�Z�a7�:�pp-��GN/ي�.Gfg��R����pS���� ��h�*+q���$��ag�����@~X�!�	z��7���Z�/n��͠9M��b[�
���e���/`�0{m�`�s�p��?��m��z�R�t��4UX��0ܔEs��>e,W=�p����\��-�J�Jw��Ԙs�6�����E;#�D5�d��3��x���t��̓$��F���+=S�Z�����6U�t��[��k�{�>�����#2�hÌ(�̍��-\��}��=��Z^u��t�Τ@xP+�C?���G	���,ѹ��X<`¶��/�Aq�W�����l�wT���sۈn9d�b[�_f���95<��29�&qUν�x'̄݋F��I�Q�M��y׾E~�E�d��A��(<~ЉԫE.@�,���@�XW^E��� p+���zZ�p�Ь�J)�/K겗Bx'� _���!��:�n���FI��7A��'�z|Q9��:pL�`��8��]����W�u,C����_?uه+�y������1����``���WcλG|ʉW��W�����?M�-��6c���LzQ�Ka�I�F� ��Τ�D�k,MAٔ��3]xvKڡib�~�d��}ʓ���W��e�����D"�o4�����^:j�J���0g�^�e��N���IĜ�zSU��j.��z�}���q�WX�Vۋ��ݥ6�I镫{-�}��^�-l��D�ke��l���g�pS�&"~�f���g�Hʽ�RtH�0-��0�I�I���3�yꁳ���5�𞮲�1�_k$i��'k:��uKe�A���x�GVJ��E�$���$g��!5l#�C��:f�����ʩ,c�RGt��,{)�b+���j"��+�"���vY5�	f����'{�
�lk#ĎeR�|��b�'L�'�7�0gQ��u\��I���0��)��b�xLS��@щ�%��'i�}�]�t&������`I�FGLa�
��`�V��]^���!�8��=�on X/F0'��� �;:;��d�Rv�v��w��[��)'9$�]��.�5�{�;Wպ�m�^����I��w�Aj�0ߔ��D,d۞�����!kiUC$��{�8񪏓 �a�R�7�3���WP�7ٵ���:ǩ&�Fg+p��;�jys�B^L��ς�[�!Y�A�eaE�An!o)�yJ\�hΥ�Y�+�HJ5�s���qL[��[!J9�.!6�'4��L��"���d1ʫ�8B�u��phg���qY�KIm����H*����(����Rk�Uy��)�C�4�̛Զ��7dm�2���֫��J�-Ig��q�ڙA,`B�Y����x��I��	;�y����f;�hP�F%G2��a*�"N�t&������^Ӥ �&jtS�!+����Oph �bw_-g�����e;�e�H�^M�>X�į�2^/ad<e��蕪�̨eIO,�m5(��%�/�!lt��y ��\�N�EV�"ك8���S>Gi��6���ʻ�G���w}ţ����D<�m�sZy���-���2U�kf��
�2XmF�޼�@~X~d=5hCX�2�R�����lE���߾�Jh���_ ���p{�����.��?e�7�ʷ͞�v@a(�yO��G��Z<��*�6/��M��,�H�O��`�>���ލ���׭��7�)t(�Ly7�53���=`�t�n�aQ�� �ʮ,ɢ��`�5��?!�&)�m�\eM'� w,�����4�����
��Y6$Q!s'��$J�qڿ	�hܙL�o�z˒��<�b�wb�� ��X�6�3��W��9��W/���_:��-�gNRC
z�M�����{𔚰	f �bqi.�/�b���S)­�d��Z�Y�]&=�7�%��bה0]}䘩�}��u�G�A�j}�ّ�a�J�fF�Q�!�_��R߼ҮEN}is�ƀ����P���Mk
�8����;�f��cXnR���������E�t(��=bR�J�w�K)BGo/i��r�E`M�s�6Yg��	�Yv���5�J'�F�����Q�"��q���(L�d$qgr�8U/�3&����s�A�������^��)����f��p!<._��	���)�>�OX�������>|����\��X65���%'���Ю�G��Ҹ���F;Rl�4��i)������()Y�F�\�i3vYPĭW�y�2�~�eh���qD�Tp �c�[,U���*;n`[�g#��oO�n��LzF;�o�n"'0#{���J��;i޲3y�"%-o�����]p�z�aw5
����T�nZO���v�Ϯ�nNu�׷#B��I�"1u4~�i���� t��.��\us�[µ�*���Cxq�0�Z�g�
g�rwZ�߯�߹>�h��Y<����>�}>�'q�,Bؗ�׹�_jL��R�MTH�`Qo�4�� C�ؓb��Y��ڹ0�HJ��Z�N�H�q��h�GA�;7Q`f�� ��R��
�@�k��= C��s���k[��Ao���v�;��g5���|K:?T��M��?��,�$]��7�z�խnǋA0Ï�-Y�76�f�È�c��3M�`;�lWbA:	f��R^Ldȩ?&���a�SO��q�n܋�^?�8M��`�QԹ�SU����N�v0�y8ꭂv�+3����0y�D�yW�X�l�Zsu�F٬�rL߸��e~���ݦʷ��XR���΀��]zy
��
��>�FL�8�!NCI)����-v�g+8��
]=꤭��I��:��\�HyK#�&�F��F�4Z��J�8Ds-ȒG�TU�l��NE�Փ4���!��V���I�JSe��G��b��ޏ�v�@�FB�ZU���<�������3A#�D2�M/Jz�(������AǓ�MrQ�:�z� �=/���W��}�;nۮ��x_�rG��)�؋��
�I�T8��"}�˩���֯�i\Ȃ��	��뒸{bLN�ƽ��z�4���tn����\`6��M|�e/U�	r;�Ǖ;�Ew�.Z����ʱf��J.'J'h'�h������|��� 0��Tb���=���g���XOW��c�E^x���i����Y�`0jҩG����n��ҹ6��Tz<���`�h3��K�HWꚺb���z$FP;y#	n�������]2{? S�2�o�u�9[�w�Y�����$��B�i��]^��3���m��W��Ʊ|�@���a)i��F�TKV�R�<7]cuÏl�{�a˃<�%'�N4��ȝ;X-������x����_V���x�.a�P�����@��=\F�7� �<�I-��̚'�ŗ�_�{��(�J���:k��R�ѓo��ϒV��~]ovx'�}����+�O�U�#]�t$l�7*�P��-I�<	�(��i�Q�s3ɓ�o��9�t�B�1q��5��x*�X����2߳N��덠	zT�w��=�TWCe�o�A�:�`p�Z-�~1 b��qC[���@?�ZT�S��z�*��    �#J�IU���a-�6�o��	t&�0�YN��s3
� �σM���,Ϫ�Ye2��4�o��/�ٔAZ������&�Â�~��p��IB�={�
���/��
�����S�QzfkI<(����Z�������(��˙T������X1��j�1K�v�Kx\�/%�&�e�Uj\����=���t�YN{���L����!,X<�
��ަ�{��_ɥ}zh���2�d� �E�m1w�}�;37T��׾7��rH���J�M����4��'2�#F	yr��b�4}W�~d6l�R�FRyk�Z�P��0��=m���n�"9Ъ
�@�qCx0��=��]�&�4\W0d7���ʸ;	��4;d���0����|�]4���3�1ӛNFa����4�q<�܌��w�W4�$�RTi0���!n��xb$.��on,��I&��8��1n�B��!�+u�\�F�����~-��3X(H��=��н~2������^!�z	nÇb.�bn;�-��!_��,��#��#��hT��$��"�O��-���aߺ���E�f�Tc�L�w���#�Ԏ~��p�.?�G��'�S��f�dD�Ay����Bm�;Z�,8��3Ŧǖ���@Wڦe�к��-�b c1u����Iw�1c3�9Uj����n~;��~@�N
`����Vl���ZjP�cԋF�$�~���$�(��L��	9u�8�k�3Փ+��(�xȮ;�#zdM䜆�U�l�u�a��l���f�m�lաLl��j�k�4�]�����%'@�2��ڕj֚�tHvRK�A��6&����:��4U7}_KGe�wx��YZ�σ��z�f��g(d61N&�CL��&�1���ss�E�e��Z��JG� ZFc��m���
�1�W�Kd%h=�����6�������KY�r]s�� ;����kM*��GF�B8�����a_���g7��?>����j܇�|�������O�|~�v�D��k��Y�^O{s�QR�KY�Azt6e�F^�fJnJ��c����	U|<��|�ώ��y2�����_�`f�{��c�_2���8�������!�\ȌO��J���oo��N�v��~�X�o���8�KG<�����t-U�ȇ�d,=����{�B��&�t_���<��O��{�g�e��N���3^)Lټ�!e�li�:R,�Z�����j�6�K#��(7!���H#@U{U[����hd�
��]�0UFj��۬�@.5�~Fe)a�".�Y��2<��t8fc�Y�p8J�+�Q�$�	N�iG���N��BMl������DH�B��:x���6�MK\��n)ѳv,�6vv��-�T���L|SYa�vje���i���� fue|��͍�@iyT_+� @��H�(tYmj@�C�,�ڰ������X��Y��O� 7@�%�˦��_��qQ+58wCf/�F+
�nre�<T��5 ��Nd.��sx3}�]�s�dM��!R &�8�Ń0��d�&��Gq` z�=,�4:sVˆ�6,�R��=L����0"WLU&lL��?ݠyG����2�By'ߣ�~t�ѝ�e�{a���f�E)6���VC��=*�6Z�u�v��[$��qPn��Na%`6�� #���!��uX���ox�����<x�.?�4f�!��Yl�xI;x����I�;Lw%�*��M�k�G��٦� ������h�F7i�"��N%�W.h�f�=6n��`�K3�\��>`Zk�ݨM[ƻۉ�I��GR'���7s���h�\ܴLx%�����S�<�Bi��.��t�����h�{o.qL�%��F���&>�ۢ�mv�
i��xQ��o�ʞ����L��$�^
�v}�DT4�GTE��p���ݙ����q��t��aG�����+lL�����4Ɛ�]:fx7h~���U~E���n��=7��&MYg�q�`� ��S��|�h�)��m�l蝭0�W5����fLFt�G�+)�`�>�y�^<D+�9�͜�m���َz������C�W�#(���\�P�l�Mo�g���u���}E�����&��-C����oǘ[�l�/CXF^f1(G��]YVa���2.��}���w(z��!�y�r��Ɯa0c`L[[��k����	nD�+Wqd����]�#�J���O��1����5�˔��\���u��uO�d�����i	N4w������=P#7�Kc�i��351��ˬ>�.�|�gs�4Ձ�FC*|�g XCޔ1uG\,߅)�Q(�nz�8����q����a`"b{�WeH�ۖ�lS�T��7`庒�!�	a�p���`~��S�;S�ʎhn�Dx/��H�~��"�P~�e(��w9>�uI��I�<)��Ԥ>j"���j�v�]�ۇ�pѦd��d`�q�� &�$1ҕ��d%�:�+@(|/�F_�#��?I�F��u�nҌ(A����
���v���7i��7A�t����F��+,�����:��Y2֋�2_c�h;,�\ӯ��-5������|Q�Q����{'�kJ/�+��aw�7LC�B�E���c���Ӕf���x@�ϱo����?w_�b1ٽ�5)�I�
j������*q�&��c�	i:�d��z#)�&.Ji����g���ZM��}t���T�W
j��u$6��5�����X["'���dcXZ��`�\OB뫊�3$���ì}g�7��\_��p)����֛V�;�<��+����]Ea�������=�'ִ~F�a���pH
.:�=�������|Ynf<�?�׼����0K�m\�^2
�Q:��$���ǁ�����Y�4C#��Z��nO1�^�
z�S\�Ԕ�QE���O�;0��8�p��͎k^����.��W�ɜ����;���̴�|����*YW1QV9��+Gt����%���p`T�Q�0h�
8��zD��I������I�Ϊ*҈�d)�<i`����7b�5:�&��Xmer�9M��Un����?w��@wC�YS_�H�텃��+ńM����-F)��8"����&���9Kc�2j}nK��1˴��s���>zsX�E\�D��o�>b�1�.˅�D����,u�6k�#.*.�C�'ޭr�Ҥ�"���g�HnL[J�U�r������T��錳�P�4Uy��r�U�lQ>}�EvQn�,�nG<����a4H�4�q<��� 0���ґT4O�B��8r.���w�[�����HЀ��Nݚ��l�Y�.\��@��$�ϸ�O������ړVӧd��0���x�&Q:��X6�Xvc_T[|ϧ|z�M�dl%��E_C�h�j����`���~k��59�^�;:DX'�����+�)e�-�'�Go���)+���׻���UQ0�oq?p	�
�C��TZ.lT�"??p��k:�8�p�Gl�@�
6x������|�f���>���-���g�Ń<���B<.ޥU�K��[�|�o66�?t�m�[=$�χs� ��J��Ϸ��˰6����uU��"���s����*��R"M�I��GZg�g���0��W�5�W;
����<q�� N�� ��&��Ŝiñ�٩����m�7dΈ7!}K��U.ٛ�fx���[�ԑPD�B}ܱǤ�����:�$�������f�+0\\�Ǯ�qg�ɋ2�58����7��p���M�AW�k���<t��}8��
������k���yt��%P����M�CG'��䒬-ԙ�$���XAҋ����(
�hԉ�q��	��'����.RTHe�L��]E��f���L����~5�9j�C��J�ZM6U��(�ߋ�^���(��4q��h�Cx�H!�*��R�ON�7[�.����"7��Ox�,�f4?��{���������o�E��Znf<��.y$��)Oj��ax��Qڎ�)X���·���qÕ���ciyVp�jX����~M/*i�>f�J���e�7�S�)��u5��FYo��`˅׆��|���L��#鄌l�    �C�i���%�e�Z_����<nX�~�
�!�����������n��rs���ů����W�w	��}����no?���Y]C��85���S���)v5�T͗��f�O��?�p+?���_ѡ2os���~�����+tgx/�#=�ס{��E�l]���\�SN�{*״g$Sk5�A�b����?Q
��o��R�Xߨǽ�&�o�h�&X�D���@w����.�I�{Yo�u>�Tc��4�d�=�R&�&5��(�8�6I��a&:�^�DH���	C��T���5�8�65�O�u5��$��S�O%���9%(�/B��x�ҹ}�'��?�E�{ĭ�{~n�\\T�MKyH7������1�ڱ��irn��_�E��F:g�k�&�z6�B��ڹ���Q��Ń:���L�WW%M�7'L ݪ(����)��5_6 T�S5
�O���� �t���_�DI�n�.���"4sD|�RH�aS���Z-�0���0d��}�3 lYe(^+��̑!>�[��*7`��-N溚�":��T.g��4���Zq��tɖVּD����9��u-;��lۖZ$�]<_U��kRgz�	0Ƥj�V~0�k�b�Ǭ5�Q/L��lY��~K�XKa.� �jl	i�(��/v{��8�U'�#��ڒ5�#n3����$Qw���@A%q/*�H�(�� �w��M`Nk�?��t�Q� Y�R���O��Cm}lP^]<d�J6ǲ���D�8����N�<�=�\�>�Y�C^(f ��!d����dn,�.���E�?c=I������"�yo����Lΰ6Yτ0�R�ҟ�9�D�e 5�'IW��bi�r�(�&y#�\�j��k�e `�a���h��I㸬A'sN�:.�`ώ6�R|K��n/$�-�eM#�hD��;h.�'%����Y�.�M��W��h�P>��md��i��o5�	*P���N��I$}z{��ehԚ�E�n�S�8 �7H眵����`J��TM
vysY���5�\}��_f^��Q�����o_�S�l��{9&���/lx�i4���G�KI�b�B�����eLB�'h���މDPC)h��m@��ȅt�(U� (Z��|�b��� G�F�P�E����eZ�e����C;�\0H�g�rv\����w��_k@��cPH���'q�78rr�~� �YP�y�v�~�D[���
����+�ɤ��=�ż� k� ��g�6gY�����VN�S�ZV�EZ�M�:܈c���&��J8+5�l�{i!��}:a��I�Di4N�qG�N2 ~�2`]6�vE32�~��ТN�r�J��pm���d���xo.�,���dJF�S�t�Tu�D���7���q��)���[ K�`Ic����s���*-a�pZ�a�۝��m�=P�c���.�Qy��x��8��ir������H��5�{�����\}�Ry����:���j���
l�ra,�J>	��x�(�� .;ϥ���m詢�B�|�8ɞ�P�*
[i�qp[m˗�vae/�u<>���`ji���4�;�J�`8�D���ƏF4�+�^�����,4�"��ly�؀�!l��D{X=m0�����
~�'�#0+k\�V��~�U�-5�ۤ{�_h�����$���(P6ۀ�� GW��UL�aQ��$FE�V��'u!� ��I/���Q���Jf&�8�cB��¬z\e���aѥ�G֬,�VHy���R][��-K�lCɚ$ՙ�^4�E�0�q���!��$0I�a�
0�"/g�ʨ�5Aͦi������ăPwz��u��<��1iH�H#�Tc��F��Q?�!�	�q?���U����lڸݴf�����,�L����Gk���],I[�k����=(٤O��Ws���p����M���f��ΚO�J���)<j$�-d�[�f�(Z���6�i��0����t��a���,ٗ�w���G�!�5B�|�=v34�mߟ�ӂ���#V�^U��#�vob���wK��f�_��b�h$���D�mv��u>�'�K0=�}i��!`��e��f���6��>χ�=�<�neRH��������X�׶�:�(�=/{�6����4_/7p���-�瘧��&<��/���(	Z��=��q
���! ,�X*�s������G�^8�_q�����_���qG��7s��b1���ݱ�H���,'��y�r_���h��4N`/��^���d@AlS �x#{�5�q/,D���t0_y��dʢބ�汧L�m��\��G�-X��ê�U�֦'� ����UD\��&��Zß4J�|"��-ڙa�����j:���.�o��d�A
����&��g��#MAsֵ��mw}F�B�7W�o
�r+���eۉ"��\C{�z�����rKY��8�{.=]�t��7��n�-�Z״LjDp��V<dT�l��G!���>�G��!_����g�Gf%k$@_�+�Β��%񀥫��lϡmm����u;�@BjF�v"����}.7�p�6���5�NG����������X�ҝ�j�r���%�u+qI2��p��V�)f|��>�ɗ�g��4�F���+�k��]�,b�^��m��"�-BV[������ȰD��K��*$��?��ʞL=��O	��_B��ۆv�7�Ϳ��`��	6N���h?�2H+0Y�)���{���?��������ك���!h"2�Cuϻ��'�WMg >��Y���ڄۃ�v�k����c!LM��̸*w��
-:���߃�R��������]F7�+��%ڷ���BWTm�=G�Jf.~�X�0�rȩX����&�1\a[hM��+�.���m-�=�ϔ��1���d������#�ڬډ�R�t��ėq�J���`�޾�:Te�ԟ��xh�95��AW@���h6�n9�v�G*�9������&����qԉ�q`�n�SWrU�j�JUM��Z���;=x�F~�"eZ����[�Yn����bX[-�aO����r�sd�U��|V4f����R <C���6����0R�m���I���O�]��h���m=���P�Ǥd3.�-�������K'I�h��65@��Q8��]���~f����Ր�0UЮ�ұ�'вj�ϋ�PhH�@�����[�0c�����~]|�I���='����uQp��Uc����nv&)4( ������"��UT.��v`$zC�HX��M����2����Zj*ǣKX�kQ���B��Sp�SL6�mk�U髕p�����j"�U�PT����?���Y�R����!�̏���O��$�����\�3�ΌY�%ϟ�
�YL8�#�E�^tF1�Q菂8Bv�$0��Ueǐڜ�H]�Wk��h��hF�L.^��U�_�|N�T�����F��R��wjz��S�I�ڒe�*�<�tZ�8ZN����,�[25�,�_�+
2Y�A����-l��C��K�Li�� I�	tu���4LtF߳^�M�M_1�\GL���댹��y��פ�+����3܋*�K���՞�G�q�yq��Զ��ƚ�W����U-�Ցڎ.wY�J�,Mhmz���cko�0�T�o��捚�+#9�bA������W���n@K���m�ƪ�NO�է�X���s�0�+l�͙��*:���J9�,��+Emf���a�?��ͧ����ع%�"�S�i%�D
����)��F�W�bʨ��^����q&y��;�=[�j� �/����a/��(�i2�D�$
�ӑ���5"H��d���T�]١#T7��+zp�_�֋\5���8Y��6[K�iFڙ�3����z�͡dO��	�Z�$��v���7�>,�����y���\
��$���j�ۙ[��agL�a~G\�Ͱ������z k�q˒��D�Jf췊[Qz�_��T���*��D�X)L�SHx�`�s\��y�N�~���dq��;�^!�Q&f�    q��k���E�p6�I����0N�� �� �����P�r��4�R��+��2=��*���WN����!fQb��/�L���%}�If��N�{�|���@�G�^I��V���(q��4�`a��}��[��h�X�|�C�،·�B弑%C���	�%�j�43����`��}�Ϗ�Qʗ{�`/+�f�5Ȯ*5�.�B��@�������t�B��ʺ��I���Uqk6�YA���hL¶��Y�C+�2�����&�O��r���z���17��l.�Myi�K�ܒ�>!㍛O�!K�9ZQ��h~�i��=��ͳ�#�9�XY߫���`�Xҏ¸��t�-@I'N����i'oy�犢B~e���]����(W�hB�YERĞ�u�2�����6x+��f9�MǱwz��	�)S�ȵd�o�rv�:2���r����C;��t�U�"账n\F��~�+G70��"@���c{J��r8G�'���8��B4���UD7��,����[�g`񫮠����kQ�:W�:��p޺�{�Km� b�j�(;�{prY���N)��D�1�mH{^��aV�
ުX���$L�4駃IG�N��[�}8����қ��LuΙ��T��w�y�B����a�q�8�;�8��·�M��?�q{z2�lVvd��4�� L�ԫ��? ��P�r�B��j'�w�I�DjE�ܲ�m��3p71m�jOm/�Q�7$ة�e-��%��7�R]�	e`S���� �)d��$�o O.I�.Y��2����8�p��͎k�"
��[0Ĺ+�G�7'�{�X{��S}F��fMC�����Y�|4�P?�!�G��������57r#�>�~߶!����O�{:��N�wƏ�HIܦDI�,���PER�Ǖ H�����Y��'�9�N�˹�X�����W����w�6�u��<h�ڊ�Ȏo��}*�V����j�T�����o�y�lJ׸��]�Q�')ؒ��8�B�c��!_��Ì��
7Xp���cR�u�gS5bkܡ¼���k0���?��Y�ӛ���龩�^k�Y���ƎB�ѯ?��珕#�@���R���8y_ѽWl)��":3�7}��>�81:�o���eǩR�>�4��v�|����\(�L�7�Ҟ�BMr0u{O��fR�����ᇾ������l�j��7ʛ�v4=E3Jn�C
��ZV]�OB6劗��Jx����.��_����殪a�W�N�ě��j��)*�3)��Nu
�G���ۢ~����P8i �{U�ʚ`��2�U!��O���t�l��ӽ����'u��f�ٙ��)UZ�����n�,�ag�.ߣV;�������J�hD�(��%���ˎ��+�����FN9@���_>�k)��w���|����Ɗ��ۦFJ�%1.��9���kS	��t0磆����C����8�*!�-��8��Y&/OS��kYZ�<�����R�֛*Et�>w(�(^3� ��S� �#p���C��[A�i�#�ڎ���Rt��[4��-����x3�A�J��3ȗe�{��6tm5�;S��A�P'}���Ԏ��K�_�����E�G�Z�J��l,o��ژi�TJ|c�4�c����b�lX��E�0}��A��JF�͗��"����j9��b�<���(�De�si���Ny֪�+?�Ҙ�ܭ��ҁY�f��^��d�a�ttgVP't�]���:N/F���p�0o#��	�">�P^�5k�)���N�%��b����T�!<��9��#�`��D�T��+�4Ev.��9<Ck��CZ�o2��PB'�;�s,�;�J�9�o�Ǻ�iаϩ�mzFa?N3�GM��'(�/4�0إvrQ�����L���W�׉�C0��gM%�9��VdO�g���,��:\��pb\N���M��ᆘ��%�w䵳#NU+V)�O�4n0�x��ȗ����fF!�
�����{v�
�Qt�n��h����C�"�xf�>jVl�v��ջ�2	N���=;x�ȩC����c���c���\��,S�'�^ה��%hH>;�ip.a)�ik1���O�E�G0H�`y�)D��9,_���"��L���ح[����n�a��/ۺ�p�bG�	�b�G����K����f��,��GJ �����O@×��|����[~��
g��"#�㽌����U'�G���F��LL�
�NE7ws���7Rb��,!FQ갷`a��\��|N��¡X��NUL�n�/�̛�6�a}ǉ�����3c/P��w	�A�7��EX���%L��ESs nZT9ϸ�l�L��Lz�a���V��I����s�S�;��(�^��3"3	��cxr��ZTG��X�c��4� ���}����s<h���@���MyFN��A|h�� �99A&�v2;Z�qfw{��]Γ��bu"�m�^G�,ƬqЧs��QѪ �U��L�A�h��.���G��2f�YBHf���¿��W�N+�/X�����S�j�a��\OnU��W(�T9y=������_�"K�W��y�T>�f
��yՀQ�٭�)Yk]6�wy֫4�m��S�l|�������2EQ�a��驗��aO(���dih�����ܩ�������H���s��`}�X>>]��S!S�s+��w�d�����im���=�Xb�I���*���I�J+�H� !���|K�S߂7�?��Y�N�7򔼁�P�!���2��6.����1�-t܎��ɛn]�*��2�^���;����e��ߗ�M&'�w���X�:�&"|���<�k���Бs�Z>�!�牉��h�������C���1pg�?툫��� �ќ$���F�Y6\[d�ٓ�P6��Y����z]�pJ`e�:���b{���$�:�ޚ�"�=m?).���
J6π�M���#ͧ�r�V5�j,p���h���
*1��T�V<������UT�U��<8^�}�'�/Y�����P�l�=�Pɨ��r}vNB{\�͖A��鰈iX0%)b�A� ]wE��/:���ʢ�-?{"�{�#�^�MsBa{������,vv���zH�r�ҭ��1WȰC�q�����u�@��Ҍ��*x�.��9�ʓ��y{F����8j�A�lv*�*͗T���H�X6�/�������o�Q�7�Kp�.�lK�)<T�T���5	th���J`F՛e��*́�K��e_.GYթX�޻�K 	�ZF�s���T_T-r�lw��t}3���C��=���}G^�Ƶ4CI��fc�U�~�q��M	v+:S�[�c:��Gh����{F�ҜW�o��~:?u�(��*�e!�}�3������s��N�_��H������g,GߌB��9h+E��e�w&zEv��=��_j+����PBS�͵!Ӯ���M�Cz���V���b��`:�Ȁ��F #�Y�zx3����b��q5���"|�㞩�a�CRTH��Ӗ��+zF���|��]\o�)�ť|}���`����P��f%+����֔�U-S�����`��,W 5�ПfJ/�0��j!�'���zy�ou�K��������T��O�����>������^��Vr��o��m�?��p��Tu�-�Jb�k�K�Bz��R|�-vd�)���}���=b)���љ9�~O1o�Ѩ�5�Siӹ�\kĐ�N�y���q�A�!aܿmt�U�a8ǚQT��h�6]�צ�V��p�!���\wH����b�o&ޝܷ5����:�L�t���^� W���y�l4K���T�J�!P�CS7��]츄r̆��:��,:�SIq㱋+���뛏!�2�Ѕ܀���H��r���D$;�UiQ�䌮8ŉ �z���&��,[��c��y�A4�
+y��<eer���b����Ƀ������L��^��@������S{i"ے��� �G���퉎��-D&r0��eٌ�CƾW�{O���d��    8tG F��<�Y����vx�}S	>aq��3�� ��z������+/g����~����u���������8��A��D��������f��P�mP@��m����h�~�"3��e&j��|�)�r �2!��j�gM{�����#�Z]���/�p����^�F4�gN���4��$�/F�3��GN""��1H��^�՘��>��7C���}�rR�X*ʱ�}����A�����2[e��Gȡ������ʜ��p��wl�H-��A�+W&���o�͂��zk}���u\,�ѡ���x�4�;�]��;%�I_���D�K���f�4}6>�*w�?s�a.S���?|�n!8޼�|k ��ګ��+�>,4ndK�B$�1�M��e%�:��6��u+L�g�(�,Q��e~��|x&�yF�W�u
�w�=x:9��x�G�q��qꘜU^��7����w�ف-8�;�	��>�JՓ}�(�*����l䝾}���\�䕛���?`'�B�r>�jU�j�;i�2�!I�kM�1�|��wD��rPdB�e�!2����r��D�{�Be�@��C��C��GeQ�)`�{���iҨzew���ҷ��V�:�P%�\��u�߆�{�snG$cjs,ҾK?�f�{^/���T�٘HgƲ�Ƭ� ~���n<��xΛ�����7�趞+�Z.)@��gƧ��&�D���1�::D�hO7%�����u_�
{>\�b���a��Q���)��pT���;e�Օ,���F;2ݺ\�+�E;՛/<��Í�:�7�CMb�� 8؀H��ԖQG��~_�w��L�{T�8�^��l��1Gb�$~'8FY��~�֧3/֦�"��pA+/���V!�ְ�2! h��fPpƁ�I rE��y9��ˮ+�/{�*+^@s_�!fAx�Z�{��ӀЇ�S�Y���r���+Ѕ��o�wmCw�,qx��i$@��!�Z�\�&��`�}#�]\���9�m"+���E9�({�L�=Yf2� �[l��Y�1���SЛgè.��!x�E&Ø�D�1�''4m}9���6`'	�m;��Z�-ynq��I��3�C7e����$龟�>�w��0S;?oU�n��d�^E��?��@|(��9F*��}2�*p`q{<	��ţw��E+ �<�d�׾"��Zeru)[Y5�נ ���m!���	r�!_}���.��r�C%<}�[%W��u��������B�����^"��
�^ݿ�M:����O �\���ӹLv�W��?>��+}-�ݰ�|��g�?~����/Z��8�A�i, �,��7����\t�a)�ۓ�DzH��&�Nҋ����Q�͊3�A���[twǓ��Q���d�f��z�3դ�p�瞳0|HF[�V���аw�e]F�c��ɜ}w?lk�R���L��������0��X�R8��#��f��*��{�C�7��C�ƑR�)YRz�d+LI���x�4��+ |�K��$E�x��W� � v���Ă�L� k�_j���Ƙb#�9:�3�:��I��$���O���:s��H5�ZmR���|���c�0�����w�j�<gS&Tw��\�X'�����ٺ*��Tm��,3{	eE^0A<���`\
��L�/�L*���L�y�$Q���	l��͘���,fOaŏ��1���Ӏt�s��#����.�O � ,+��(��,�^�<[��h����B�]1	m}���u�����(�y��j�� ��|E"f7i�w�2u"@Dn���v�O#����re����V 9j�Q�-�������R��b!�Db�q%(@�x��M�
��u�������@��H^컟h`�~W��h�~VNh#����6��ȥ�Q�=+7q}3���e�F,(��P]�^�3����S�/�Y�����f}6Qn�|���ּ��^��:u}�������������?�ųVA������7-����+���]����,��[;��4�B��/�t,;h��u<�ΝU�i����?5n�<�I�q(���S��$DX����*7������[8��I�vD�.�K�U�(:�����0&�c���*wcs˱��r,M5j7��Q)��Tμ�����Z�S(�~`-˦�����ɇ�W�ax�ř�E�W=�Ϣ�O}�D}b)[��v�1�"�ؐӰ%#�3���D��
��u�0j�1�M=�TMBt|�r�L�d�l�6/!��
>g�ge���k#&`D*H�H�+��6f �/��vqg�h�㖗v�GJ�zR��Ib�� 㘟��4~$>D�"6���U����ԟ��n�nR�����
-��A��)�צRа�A�g���Y8F�n~�-�1,E�,���LDF�g|�>u���!ڰtu���_r^mvy��H֕H��U9�ؒc<�����"z}��Lx��f� �;�I����]���Q��4V�<�����	[����Ů��%�$���^F9v����n���w�hlC��ME�� �Z�L�Y��ST�ɟ�|�J��f28��(�n>�QG(�|��|t&E�e�5�R�$�s@�w]���LI�ϝ�Y)_	x�3N^~��UlZʋ�W˻t+˗���1*�Pc�<��-w�]�s��~+q�Tɔ�i�Q�{�? [����L~����UС3�\Kۧ��ۧU�V�Zy��WO�� Q����j-�%Ն}W���-����1|��Ϟ�j�l;
tI�(AB� C9_�%�
	}tln�����Z@��Җ�����7��{˄Oo<�^��˅<2 }���<�W�i`t�p��q���~�����z�����$��i���A��nM��[���ܼ+�#�4��Q>��D'/�n��3!g�(�utf5��1�Ch.��棿ȷ�s�E�(��NR����>
5Z#��6��$	��5��yfվ�u�S�^�����hE��ן��h��GDC��MJ�}���s��Ͼ����ҘO���'�h��iS˙8Caҏ����������R~�b}�x�1#��Ѫx�ʗ��g`
��g� �}�fq�~�h��ݔX�y[�9�ˀ%M�curXL���i�ک#Y�u�g~�ʻnv|���g�b�թ��C���]3�`�VƋ��6�	_w��[z�*��e���Ё�ί�����E��8�3�Cs&�1$
M��c#-[�	��8�"�\wm"�;v|�k'2���G�1��u�i��'2��ϊ�8s�)2Lw��n��鴡TK���/w?����뺄��a|�ۮ|�2_�x�'�a�^$E��,��I�\��� ��<�b��-���s��ˆ�ž�h�����2]��n/�0���(R�T�[�2d�$�p\:�m�d�����Ng�,b��Un�Nw@s?�A%�Yc!ǣk��p,������Q7`T�eO�E���¸a�'��q�	D���+g���V�	���)wvʝ#��9L �v�t]x_�,V�Н�G\b2��<��9���'�bd���'����Wr��ډl Ȗ8�z�Gc�6�f2;L�/G�ݬ�؆'
�l��	[�G�
O*�ξb
��J����Ë��F��h������)���A���j��|���sj\]��{��D/Wksܺ�V�g��]�b{���J�a����)NC�F����s��|��쫶�0�E�q/����b\�G��{g����J��Pl��Dlp����N#d��H�Y��ɂ�z�p�O���/�W��r��/�'�A�_2IP	P�xϿ�S&�S�����*�v���h��X�伐�0h<��I��K��e�'%̙P�t�f������,�ɮ^�Y-���)���"{
�"����nuŐD���(J�S?'��׮C0����]���`��Uk0�#&-�k'F1���ۄ�dPТ+z�r�J1̄�8��� x{������=�f,/�L�]��n~mc���Ĵb⫟���A*�vW��&2z�P4i��2����C�l�E��v*PJoK��ꅺ#%��ô�w��5�ebD�qh�    SR�vv�0��d�j��� ]�Q��4~k���9�|�?����*�|I>舼�W,B�]�37�B$I�w~Y�,@��gЕ"�ª�sn��z�Q�<���o�͞��O�hk�bu/��F4_oV�ۙ���T��?�_Hݠw��7�k6�!ηW_i����\_��^�Z/����o�Ճ%Q�_��q9]���jx��BA	�A>��!nf��P����'sa�8s�<_�Y6��X����[��+�ֹ��v�	�S�K� ߣU8a_�+묽�b����BsO錠1���W��6�`�U����+�Wd�|��| K�^F#�{Q"��tE�\�f�1�~o8�;N���A��d|Ҏi"Ԋ56�bdF�~���X��,.�Ϣ���i�H!L�D��bJ��	�3g��A����߲��4���谨Y���o�O�Q>�j{ΟA�!������>M�@m��ŷ&�p=7�:��ҌÇ�.u�i2�N�CiT�&G�;n� ��l��������;7��T�x�"���bsW��@Re�w�&l6���Z,�+��Aݕ�~��VY�YO(���NړI>�d� BN�M¬��l����"��
��3�P0�P���m�ib��<�k�7A�ୣbm�h��c��e�|�>��H2��)=�Ļ����2���@I�Š�!��F\�W#})1�N������5�;3�ւ{6g���#D�e��6�z�^�2g�1�����p���"��+-�|���`N��\��_��k�)��nv��H��~r2`X���E7vD���"+��-��U��?V����"J�9K#�Mb��� �V�Q����F� X㙗�ތ�]h�hD�Y�	d�쒗H�
5���=��3�̬�ԍu��e���25�X��>_����u3T��/f+]�W�g���>�ծ�ה�'j�_Y�磶S<�/����m����8�ؐ�=u�� �C�m�+M��\irY�OP���}j�<n`�):�*
uQ��?yv*���r��z�=p���*�^�l�a�}hI����'层*j��T:�Ƀ�1�BQ/�/��0Ӣ�$PU��EE�p��R�!�j䴶g����H�ylC_�||���L�ij������Rx�^X�R�HŞ
k�Zj�`CBU�W���N��m�&�m�l��栠�)~5��tz�8�	͆0"٦��.������]M�'�p�^Ȩ���H��Rˢg�������� �c�?XF��t��M_IR�*��Z1��Bx����9���C\B��T>@a�Ɇ����"NXa��9:����ц�4_N���a�M�T,��m��^��fj��'�B��Y$��v<�ӸqL�d��7����P)@��#��hP'�H�/��g�_���0qM?�+���M��X@��w��}�	�X��>;,W�S�D����n1��qR�.��ꓰ~�j+�r;��6�J���sK[���fq���,��Lr��2�i6g��v[pܢ�Y���� ���IQ���)P�w=����U2h���U��T�ʿW/�r:�[�fju4�K>7�Ր� D4���&�֮$p���O��^�#~h���-Cf�|;F^E����(s��jR�^J���ѳ�e�O�<XW��\l���݃	\��ܤ�p�_u��?H�L�^v�W�.0 /���òД��M�0r�������O��I�ߩVލ\_7�*T�b<���pe7j����=�a�[Ό�w�C��A9|/t���.�ڱp��i���fgm�,rFR^�4�ܔ�0����E7�w�^).J����2�`zȢi��{��>F��sq"�>f-jo��#����KXth����}��N�?�],�l|�����O���ɘK����%@�K᝵��;y������)�/*��4���'/�'�n��(_ءD��4Тi���ҧVF��s���J�k�D4�tǻ@bAn�D���Dr�jƚ[佈v���䝣uթd�,�!J�U>r6'Wq��/����E9��b`����E��u����}`�5#�x,����Z�$�������* A��)�[����m༂�p�V$�:/�ȹ�����
�,��%��΂�`5�S��:���.��r�X����*T�k��a!�f��lWm���ٗd�*����+����#�.�q:�m���۞00��Z)��|�Ҟ0��Do�|�{�_�L�ř��l̿ ��*-���=�~w;�{P/S>x �)����<��CVkP��� !�wv|;���%��T?�.�E�ݚ埸E6c_�w��w�jӣj�_�
����%?{���ckuo��	�����~�T���\n����8c��D�'EǶ�د���(����e�i��A �E5V��̋�?�U�HV�"�82�s3��5�,�@�[E��9�Q{�Ku���Ӷ��P�S�Q ��t&r'�>K>I@�y�y&5��?�	���C_�,�VxӔM�BwY�N�:;%���`OV[��}6��Ds]���P��q����C��Q)Eel�	�:2T��.�Y�;q.��L��ʅ�����f�E���l��!���̕L���]�ʓ*�@Y�]�$��~&��L���ݟK��������y����I��}��ɿ'����<e��a���<l�8�4�Y�eU΄��3�͍3�$����*znt�VN����uB� ���uU���2myC6��
�����k^(6�b��܀#mU�����E;�64�0�]OUK?�r��\����ӊ��΢��|�1�^��n�ۇ�믿�b��{8Aߩ��4��4���BK�i5$Iu�H�b�Fu��`$�E��������r�>d`��,O�u�1_�)Q:tl�b�`�lEV$y������D�~�,#u%M(9z�2n4b�1O��'�1
 �r�Y����N>*�~)��蝉a/É�ҹ^j�"�Zm�c1'��I�dlj����1�|��p3����ဢ�{t�gyZ)ξ���c�N������4�A�.+7\�]fM��д�=�p//�>���fE��ưLa�v?���VyӨE��7H�g�N���%0!��|���I�৹��N��J9�j�M��D>��:"{O
��[;�:L�CGsI6�:�ϫ�B���a��r���G�P0��˾��ܵ^A^��[��
Y|<�ӢZ�
�˻�PC��eo\��Lp��g]��(Z�@ul�sBUΤ|3>�_4�KF�����(F��<��c��,�фS(��� =R����G��-���G�9l�xH�]���wrQ�^�/2�2����|k�����/A��N��1k�H��H��m4?��َ$�*���	yRXQ�61k%#KM
�z�MBŔ-��2�j}�0����i:)n2�d0f(&u� ��
�ԓ\�t���+Z�`F��
rd�m(�:��3Bx�F�R3�i�����ү>��?6M�'��x'<��	J�EPw��]%v��S�5�T��lVW�D�/a�q���j������5�����V1ӂVA�N�j@�#U˧z�#����JZ&VA�G�΋::*�X�g)���P�u����s����1����êJ ��t����*x꼾OPnLU���r����:�����h�b�*�x��z~�?�$C�t�u�fU���1V�(*�\�"��˻�=/ٙǃ�D�@��BR�1F(>:��HZ��^nW&���E<�p�Ѥ���
j	~@�6�cǇu���}f���A �8�h�z^�}}��0;X���|��ʻ�U��@�R�u.��~�
�W�\�+R��7��M�g�-�5xp��֔�đ�h���:Q�3c�>�*%�vy��ǼS�(ʢ0�/2$�)��Z��4u�lJ�r��\#�w�����nr2�gZ`��u����8��:;<8����[�s=�ܩ�=�݃�X�c�X\�9�0US'��1U����RS�eLz^A�O��l�����W{��Vp�%�&&��z�+��!�02�7|ش0u-i�֩��iu!)\Fcx~�A]�=��    ���J&$v����IZ6�?����T�KD~ah�Oez^L[}[���j��m��L4�	Ǐ	R)�z�����t�d�����0�!�,<�����V+�ت�C�a�{qqɋ,�N*����,�X�ʟa���,�L����2�bS=�K�G���Tl&�I2%UwRU��	���v.��+��>�&�Ȍ�A�ލ1O�d��V���q]�	ٮ`��S�%�s'��qz��%L����T�h����T=dfV���H�v��lʫ}�YL� �F���펯��Q/��0��| A�]z���lrC�&/D�x�q�;��b�8����s�j�~W��bӭ���g"���8��a~{��B$������BU�6���;�)I�yV��çB)l���r�bC���� �=���$�}�����L? Ȑ�u�K%����[�X�c�X�̒m������hJ6 �lh�8�T�z*�� u��&>v])N��6��Z�5]�|?�F��3!�В"��m[P��#v��`���<����6��(������7v�o� >y!Q��z�]J��/��O���1Y�KƠ�5}B>y�yV�+y�<��Y=F����\�y�m��$9G���i����ʤ���(����G}�;�>|���N.i���f�� �l75Y�0$v|��5+D�%��|c��W.�����J�6-���k;�,ˇ��屍6�Y���l�c��-�rf3�� ^�ua�x���K1({=�~�gDO��_eQ��K�x�+c��`	,��߰��Y|T]h���B��ޭ�탗ӣ\:�ϱؾh�G<~�|��%�� 	�9+����Ȣ<�������V���e�0�!�eC�"�VP�|&o�����I�\\��W�*a�_U�Y=@GMsh�Y�e�:������8'�]����Ǥf�,���r�%o��|����mA��^������I-�zG���P��#a��1�����Iuj}��6�j��Ʊ����'
��s�o�&�WgGg'��)��w-�J�v�W��Mwr4`z�z�Pp~R�S�b���а_^���&0QW�uJǫk��f��;$*�&uF�<�9:���,�����38����]F��K������>f�>�@^ט3�G�kEΊ��u�A�t
Q�_�Q&zg⢟5\��	�t�7��$�%��$���i�^S�%�l����^n��v�@Do�U?�����wk:+K�)�K�[��s`��n�k2_��x>�e=��-��I
�g;$}��� i�a��0_b�r7��{ݢ����^&
��2�T���ᖪ� ���Yڊ�7��gGp��DY\��߽��� ��0h��S�C\Eȅ��V�h7�)���A�4�3��nV��n�g�_�z��r�V?kU���'u���	�CC&��a�\֭	�z7_\f�{w�G��v�,J��������i�\v�Ry�?����%�+�uv^�����_?|�#J-a��}x��29
�I7�{����TU�V�B9��5}ݼ���(�c��@u:P͓$p�P���XV��'�iB_{�:ey����z�6��tdt�(n��L,�,��gf��l}g��N,����sR'�!���;�]4N2،u�G�y�z�q��%�u��4[�[��4���4λL
���u$�����-�ȝLV'0�C�n>�B!ʼ(�~&�ř�����o<���(� ��5X{�,r;����ޙ}�p��7����Y��2i^��x��.o�|/o蹩Ч�/Va�}
a����06Ii���?�D��ھx{��F��N:�����zl�B	U�4�4�>wOS�\������?V�[�g�;U�2��u�L%�5�y�x_��0�J� �Vvd���D����x�҅v.�QW�J��/��ڣ�;z�f���B�j,��Eg��Pi������Vպ�3T�cͲ����f�Kߛ���K���k��f��}�ݩ�x��^�4�v�|лϱ��|�q:{��xw;@�����L�4 �p,wZF2���{	d͛�j�W'َW��*]:��HΦ�&v�2>������<������jM�n=q�t��J���r./	�ɬ���U�ڿ'~���BV�@�!W�+��ĝ�5_�#�#ƀ �ßXL��m�0"�a�]ʖӽ�S쑼'^Rd����W؎Ѧ�U��^�){^o
�'��R�)�*�3�k+_}^Ѕ��Z9pe��lU��l?�N�pgh6ȓC����2��hpY���a.�r���QY����}�;�a0=��A�j���,�L�HLWgqH"oR9c���
�v��1�V:��x&�El_�i�>ln�@�T���>"r���eOP@��OB�ZC��lI�(����~�.�_���� ���Q���d��d.4�� B����]j�Z��b���E7VVK��Z*��(�Yq7q�|K �2Nऋ�2��������+��噡�BIs��.�S�&�'��8��a�%7�~�k Yr��[�|��`�@�< �X.7�_á��L�� 1��E����; ��$��s��855�Ԅ*��zXR�Cj��dQ�~�E�$s'l�d��ˠ�h��NG٪@pa��=�Qg<���l*�"+�3�ޔ��8Cr�B-�8�|,g3����L]6��t0��9J>1RW��+�O����y�y���V!ɋ{c��UDX˗�c��~
3cSXY�L�#��\O�	]������;�~�%1k<jyQG��<1�g��,{MnȺ/�����	�bI��vKx��f����1���
8�Ju:Vk��V������r~y+H�l\7GJShhZG�>�԰;z�C$�"��K��;��6��QD��!U�#��p$��F�}��7���Vޒ)�&.�#�|�����2K!z�\�ձ�o��~ �0M��_��1�?xYe7]w~�5�	�vp��O}������T�����چ��;�D	��|��I6J9�!�)I���g��x�~��rP��U��YBe?�<K ����!�R�3�DRy)�x� ���|9�|�f]������qty'��yx��QU�����m��,��PL%��&���+j[v���͓!��j�'���p�.gqn���3�C�$�F1�;�T�@u����ֺ�)�`k-�~^���31*2w�L��m3o`�#/���/x�J˫RBU4Mn"�G"�c�hhx��u���XK�	N���o�%�t�nq��Ge�+�y��)��*5�L����'����}���N����e����*�_������l:������g���������3��o�z�,��<�uc�s�}��F��10�]�&o#�X� ѹ�+C
�œ�� �����4��;X�x�Z5����R&�X�o�s%h�\닮�9[ϧ���`yHd�*K�q.������`%�G�>���
-k�[�F�6i���Is/�Ѱ+DW�I4,{�L� �3_���'eW^U����X=�R,�c��n0�'�J8f�ܧa<m���;Z3&���ݸ%���=�c:�)�׷];W��.9}�d�-���9t6��D�O��;k����Ի%�L#�ʵ�:� 
��#�u��3�/ޕ��%wh�j� a���gh��]Qt�~)�r�gB�gb4�%�ъ�� "���M�%I�ٸQ�m*H,�hhp�L��j�#�E�� ��hޔgm:<4��9�U 
�s_+���q�e�S�X[�ۦ����M/Ȉ�ԏ�1��qs��zY���JM.���� &��`ɩ�r9���y��!ہ��^70"��Q��2ѓu�0��Žb����4uh�H�'�m��c}��QT�a�n1��YS�������^�e?"���?iQf;���3�xH��t������Ŷ_�2��4���p���,sc� :X�� �r�6��
��&b���b���ym�tҫUc�4OL���/�/sy7�R}��at�Dr���^zD��:e��S �Mc#�2���^��gKҶp�[H`��t��
����пY��I�t�Z�P��a���AqfK�"���    ���yڸ����	׻����*�~��/7�,ˋ��b;W�����~��I�B�"�خo�NMp>�,��~����&������p���R&����❎p��C���;�>�G��|�`��y�ս̬����ܽZ�o�-�_.���_�H�I����y_W�9�^}�3B�B�s}=*�<��L���)zz�i$)�m�`dsg˥�pÇ[�@ ;l�EW����7.�^&r��\d��tc����8�qH�8�{����1����:����a��''2QUe	x��C1����Hz,|�R�k#8дv3Y[�߮�4])uVOR�u�yKlO)�?k�ns�S��O���ص��^�SW�)��ڼ�aA{'oL��	�,k��#8m�2�3,+H��_�Jp�u}�A�9Y�'�[u@���ϲГ���]u!��ub��f����z�N�v��Ec�qfH*�B�u'�D����pc1ć��#���L��0<�m��$�ž�W*����,@2����`O�e����pQc�1ශx���5� +r�}�Y�P��ȚF�.��K�"�/����_t�a���^?�8�Q���wh��8U���/���MG��=�ܮPQ����o(����)W ����}��^���Ú�����R�Ӽ�9o����_E�S/�	eR�(.�q^�V���F���c(�t>�f
�u� +�]�/"�F�:	ӂl���zJS��I��H��X�ib.��JFW�RCn��Af����]	��G,���L��>�����iM�:ЩW݃���Դ>*�x��꽣$����ޠj7�_�a�2��Xhq�6�	m[�Rj�z�0+U�������u�y��fZUYנ�|s�(��8�,8k����`�E[��'�QX�}|$v���0�%�{��x30c��B����|�ǰ�3O���,ω�R'��z�i�d�M�N�;�Y��S�N�8���o���D1C�B�Ny��P0��Pa��خ _Rێ5��H������l���ݽd�ƭ�qh� ���v,�Co�(l"P4]�S,���Yv������BL��˺��������lvA��7���jm4B���z�1}�N�W801_~r�&��Q�~ ��S���B��5_榸�wV�xw���%�~]C� y&�ݺ1�)�\���&y�Ti?�g�BfZO�M�r��Vi��*�Y���Zf?��Uح�ja�_��8[]=�Y�Q�A�������ݼ�-F�����Wd"/��8�(�i/�����!܈�d�8��Ȧ���z7b<��;I�΢��nq�ò�+�J.Ί���/��'���g��%հ�E�!��Iy�n2���2��KA&l�vm�{�l2��-%#���9�-�vSF�|��p�Z"��-������y��T�5�.~������ɑa�P"K����W��䃲�+"�'+�"�i����7*}>�>��!T{"Y��ܶN� N�!��]�ӣܪ����q�;����Ԓ�3��/��z����g�Y
��Ք@	ƒ�nB�WGP�����:��g|�(wG&b�� v��%^�ܔ��3�;�0��H��A�f�6�ձ��x�&��^�r�M,������9�\"y�G�m>΅�$��a��&���fz=7t��72`,a���W/����ɷx���U7�^�\�0��{�ݒ�'H^��(!����O�]�:�\��Y�"����)����]����][]~8n��d�@-�(3�xD*���"��#DY��~a �^�_p�`���$�2��̩aS���$` k~Β�H䫟|���"ᑧ�GgA��� Q����o�|�E��\�������[�J����qom>\����z�:��b1_n�y��\�"N��Dw��������Y�,
a��a0���v?����J/�
��,��^��^^k�3�ꟸ�# ��6��u�PF�h�Er$���W�!%m�}�P��	��8:���ϳp�1u�h��{��y�%S�/f��}��Oe���+|D�)0���cT�|���!�ҿ�y�9�����*բ �%��al�������\P����P�oJ�,o���F^�9�w�L���2�?�����+e�^���Oav���3�ѡ��:h�7�Ы��Z��A�{��p�#��O��.�?ްC����}wE�����(Ÿ����~FA�{�}�+2���|���^�Q�7��1������;	�g��`��6�O(��	�,t�NV"$���zeX��j��D���R&�p�T1۠�U����+��2<~�?6��46�_�KC��7�|�>}'���R��'���GB�Nf����gĭ^zk���6׉ė��I�=y��SQ�Y2��Ǒ���:�~7u�(����3��AFC����bM�4�&Xm�)�>�Q���(��@v��,�֗N��� ���p�n��5u����<$%SR�����Av
�P�k�.��H��>�g{��ƼA6'n�P��I�P#O;�)�-P��ݼ芼�����,.2��ϊ�����X(��B3v{v.C�u�Ge���K+r{*����	N�tP[~��,y|������t����η�w�ܰ�T#�Js >;��w���x4�(-��I�(}�$��x��i:a�o6��n+zm>��/��N�Kf'�yFE�b�ay�!���s�d��N�.��T��E�r��A���6IC!�X�x8FU>�(�L]h���&	T���V��	��"��:[�PS]VU�x|XVџ\z";H>�a�����-Ҹ0T��MQ��6~y\�YY-��� �W_���/�v�B�R���V=cY�.T{M}U����v��O��Yk$9�E������nOt����(bp&�"��)_�ƃ�i쒄XZ"v7�L��A�
�I���v�`���0��vK2`e'��� ۔"�A)FeQdb,Ͽ"�Xg��Hp�kݬ[�"�gT�[%���F�Z.����b���8ٟ�������N�ÌwNhda��|�bA�`���(_���0�8%o�63N��Ư�D�n�B&�����)	n�#B�#���e�s.n��̼H�q�(���|�-�N�+�a�g"����*��Y]}������|-Ϛ�vg�����_�Ī�^|@l��z*�F�w��j�-�C�)o��7��~��	���wb�jjڽ!�u�+�C`yn?.�}��5�e�X��ǈ[X�E�	��c#��m�ǣٴ�kz�^��R�)��)�(|y���S�&�5,��.i	�]�x'5�����U�wUCK��g����bhx�L��S�(!Fgb�'
bm1��_*Y��r7��Ѱ0�+S���"�U��w��?;�/�*���ߊ��-��72�
�0�6bǻ�����EJ�5�0<�y�!�NL}'8g�I�����u���Zf`�K�1��<�u�Xj�b��j�����!qЕ'!�S�Q�k�1x�2�]�@�$U���a�V���4���	I@Bq�Ƒ��G��`kNl�Y۴�QB$ P�n>Vc�e�/ t B3�BP�1:L��)�H��ͮ��s��:�(���{�}P|����w&���w�����������p8q�HH�����0)�-{��]&��ǯh�-V���G��L�3jv۝'��MkͽG��Du�d��n��w-T��l;`D38b��
���Q�r�<��_<�T��A���2O���I��͢�ܠn*$��-xS���5vx�C�_cz�q��(�:���ex�W5�>�#���]u!��Z��s�O�U͐M�K�&��᡹唿�Ĕ�l��ss��7���p	)��i0 �6X��A���T�/*Բ�
b���.�{���x
��r�]�r8�YV�U7a�8���8K�#���={��edY��ǆ�C8�ȱ^)Xx�l5�>�{S%u���2��ͱ>��4��'�Y�!�)���̏F��a���AbVd�Q,�&��2s�Ҍ�N;;6�U�<烮(:�����`���8�a�[�M�v�$��I��c�BɃ
�և��tX�i    =XY(�}�DFĢ�U��`|�+�|h��ތ��cb��t�+�+�#��g�HE�,u����Yt�	)Q������ݩl	1��e�Z~><e��o��`���򋟛�Mӫ��7�w�ӻ���:��Ph�����Ēo���ql��S�h�G[�v	ܰxl���i�0|R#a"�눮O�K}��Ɨ&8mnu58�N0���3�J÷���@B��v�L�_��tK���?KE�t'�,M|�Iؼ���9���w<�ؘ��+�=)=g�2ݣ۔�5J���£]2b�������h��R��t��i6]V�}�C��u����v��v������zQ��W�B�ٙ�2�^����J�o���X��5tu'Z~�멬� ��
)��{��^����뇯v�%��پ������)(����n����#�'(�wy� �w �aK<��Q���#pW+F�B�bX�.2!�r���r!���y*RO9�,��ئ�D[�y�L��`y�fG�� �e)�J���.g�w�D#wUKRV	�s	w��$�χZ�외��mj$,��/�SJ��{���g��qcHY�^�a�:yW�c�V3������:����:�G4����O j�?8�>�d��v�;b���,����o7"<�5�9��a��G��M5�&TԽ��Pe��'�9y�����`5xYŞ�[��d&C����[cpp� c}�;�Y��K�N���Uԃ�6.��F��C�����yž�Cv-D����|����4�R4흽�V�z���_v2����!O�/2,�u-��#�s*<6���80kU�|}��4::�XR��,p t�~��w���W�ƙ��"�3�`��+��阠<�\����׭��Y�"�i-��E5NԿCd��e�|xZU� Gj�y���JIKWk�$V��V�rC�~I�@n��x9x0����M���>u�o��cX��{�|�)rȠ��L2����RǸ��_	��IQ,đ����+�����:&f`s<��󡸏�����k��}B4/ n7�B���q�i�ه�
c� i=��7%���H���|���\�퓌@2���S�6O����L�w���i�O�w5���s�\S��cL��c=)�d�[�4]l)�=��<.�Ш�����m�2���B������v��A��d��/BP�L�]e?b$/���k�ph,V����L`�Z�"ƾtPo�>O�Ƈ{�3%�X����
&��m}����P�����~�nn)���J�+v����\�@]��k��p���,X�V<b�-E3�e�h�R1H�����4�B����ӑ�?�TFF���J�cꌫ�pb��qt.��L���$��}�{���D��>�p�V^M��u
�KE�6q��I�(n����U��<j��$A�њ
�1`�����]��_������U�O�*X���+�A=���^���#��7jWj�pk�C�"nBk_�G��a`���gB�g�������jGC���q,��M�2IŐ'�N4��Ηa�*��i��~P��)}`2�K��Ǎ!��� M���1'���S��� �?l}��`H#8�3��
oA*lY`4��`H��,շv�0P�ѵy7�IɁ,��Xk��^m�q��"���pRv/�
c�cP?Hg��i�"�c���'Sq�4 8�y������{���zS���B�n����]u��7}�p�.��Y��Y������E�g"/Ί�(�/3Z��Y`�*c�����T"$��.ce䄻k'�mI-��ܢ�� d��n<����A�L�lhn��ľv�e���H���ZV1�F�S�.�%��?�3�3:�"kHT�Tïq�K��L�u�l�9��L
Cn��d��x�[+���ۂ���~��MnB�@	|���É�`C�znDt4�s��\_�/	@���9�(�{����v!_yW���vթs���6���B%��;�&���uNQ[w�M=އ��JV���KrU�<ṶA#f��hmͤ��ܒ����� ���q�=}�̇���J�(��d���y��&��-�0,���q�׏���~p�����ҍ9/Ub�e*�l�QWW&�pVxP�?�m������W;�w%�4��M!Tl75a�T����c�;*���:+U�����j�hz��x�8{sV��"�!�E����2y��N�A�Ǹ��Y4މ9ǲ��UM��:���+��"?���/�ˤ�ZE!]��F��lҽ�96����z�s��R���F���6���O����[sM�w����D����~\n7:Qy�L���G'ܤ�c�F���E�2��h$e�1�(���	�Td��L�4�c8]vd���y0??�W��}�Ι�G�.�B;L;�n���(�b��	1�q��hZ��C>�υSc9�:2S1����;Sl����Ųo9����g�\IZ�5O�n@^F�|(uDQ��?�D�l0f��|Ƙ@�n�����] ����V)���(8qk�$��<���0,_n:���J/��@6��������>�[-Ois^��D?RM�Q�4fT9�E���Vy@�z��(>����g��z�g8�/;j�w�ӻ�	tЊbԪ;'_�����Rk��fۍ���R��/�w^Ndd����lL
�w����vvGJ��%"���|�x� �{5��6������@Ѧr�M]dDma��kOg*r~��K B�&������(��Ӽ@���� j��Zϕ<4�{�bΕL��L�^>�e�	�W�C)�������2����+}/>���_yAܮV&2��=�=XN�n[����LO��U4�&׾y�x�U��zo�29�P��Ky
���Z=͠^d��GL�d�%3�~G�̟��3�I���ǥEE>�3��1�$��L0����[Ms�v���˳]�vG`*I����g%Kw��ڮW��R����@�����J��0������f���1@�2hm`��a�k1����ʁ�
q6������%����o"*�|1�MD!Ƃ�OiDM�c�XN�9�Y��3]�8��Ai}K1)���I�Pek��	>԰
�UX�����X�C���g_��"�n�Vk뛫��n#�T|țe0�ͧ������F�[������*�7��G��;����V [��:�9�9�����R��Ԙ�s]w� q�� ��	'v�RG�9L��0��ɲ~ϊ�話Z#@��EY�2���ñ�>�sfh�'6��6���[�&��{Z���G��kvp�
��[��_������
^q�	7�D�2�o��b���p��D��G���@XI��=�w��1|1�Z�0]ʯߎ����8CY�wFǵ	}��=�x ��w��,;̤)���B�!e���kO�M0�ai^<�x��Q��ԣ��5��Uo�nz�V�Sre��1�vtV5�@�zq�T�A�ǔO!�j�Q>�䃲�/�^&��L�y��x�OF���xw�a?To%L�d%��^��ŕ,�;W��L4?�xOiHz͗��gJf
��VT3��t'b����b:��h`�.�	;�Y�66&� H�����9��_�G�; ]����</{��׃aE�ˈB�a6e%��q��Z����I�f�u�n{��L{��P"��+~��ݺ�|����z��]%]��=L5�K�V/*/r�O�����z��V,}>�w~\�n��iF��j��ҽ�����k��e�aS�Z�;����B(��"�P�2��1�)��}�����	C37��A�Jh
� �Fmj����ے��5��o:�u�@�):D"��ʔNf߯��*S���Ly����Ld�����<~����笒���((�8/��IZ�M��Z3 ��r(�����b�鉶L�Tb,���VGhX��׫YEԩ�����u��d1�%Ⱇ ���VeN�U����xqQe�*�L��X+��w�o�]�y���	�R����O�H˸j�.���7�Pq̈�$�[ʡ���܃��Flu|E���<    �<o�dwr`Njt?�1�]�EG�C�+P⒯��4�_ى�,�vC7OSy�"'�:�`n"42�B
��V��o����s�MԐ3�	�����h`��y���@����PSb
�j�_���d��6���}�_�����B�.)&P Ǡ�y'��%z��!�����Ǎ�-�Z�˟+p��ʾ�Z�� ������;��&���Myg��0�H�8�PoV.�DW��/A8	k2�#�LƘހ�(Dx?R�Y�lYj(�8�3	��^7ts�ɋ��˼���խˈIA�e�D"�4��c�N�v�k��ͧ� �0���$�J[�2�$7xj��.��Ȏ��7�}��, r0(Z��r���/�F}^�Ap��j����z�����gi 8þ4_6��'<�W� �A7�e'��E&(�G�w0�-�:�H��Z]3>/���Y�r֞����#q�&����N�HjG�1�zz�s�e����'����.
p�B�M�;��]Q]����zh��:\�G�.a�R��?p��#;�'�mX'� Ξ�}Q���@V������I����t���D��-�~���=p��թD��O粊��]ݼ_����_��hҦ�Q�_��?}����g%A�\���� p��DBR꿧�Ϣ����un�=&�M����(����b�S�-�a��?Y�<G�>�`�U �_}�(n׳;���_�#7[��;c�p��媻=Tي�"gTs��ۍ��`�2��Iw��OK4���n�arZ�;��0�a<��o�B����#��>̫�+��aQ�5x�nT�����y]�u���ن�=�+��Q���X�2���L�0������K�~zN�ݼ��̋R�31:+D�����[j�,��9��"��9 �};��4��v�v�s�� r*6|����Fm�.�˛�ar�f�,�"���f�6<��3tF��'��S�
ꓦ�4]hO]� �gt�vF��W�n�;T$
X�S�úɲ��/sc�^�OUf�� z�KS��!�ç��"��*U,o��0��y�<�s�A6O��3-� ?��.lt�*�Y�EWݼP�h.�L��8+��'��b�kÏ`�xR	��pB��W�>N!��1��^�(:E��G� ��^�}��ߤz�$M 9���(�dx��um#υ��1E�R�E��֎�gsO�i#U��]@��\��r�1cGݢ�2k��Bp�2�3��� �d�8%���m}@?�.���/���Uv�Rg��,s�u��:��^�B�9L��g�ߊӣ�%��������÷�����l��H&*���$�qfvo��]���9|��#f`��,/�J��Fn�ۗ/Z�5��X�G��v=W��Dy;uPs�`>�L	db��<�ROnRU�����г~2f��|�l|A?5��Y�[��{y����D��x�<}���'��l���w��7�k�3�j���J�
�B�s}=j�|k�a�Ǔx����:�C'��z�頕���*�Jg����~3�����,��&us�mȢ`1�������r�K�����qX�6�n���P�;5���QZ�0����U���L�'�b��C�ă�����M�_�8�+*�s�In��;��쨙�T7��wU+*Vn��,���ۨ�H[mh =���jfF��eL:�;sr�
7a`�(1�^�����<��Wo�~E������p�$�a�������R�]Oj��B
�#@ā; ��Η���@15��<3�������{m�"L
S%9�#�]�j��tH ���x ��fɦh8k8b���s��xc��xΨ�i�F�ix�}6�6VKдq8y�a�?�RJV_E���"���rpQ�L�e�5̾�͂��>�	�J0�;i����t�F��֦�R:Ƿ�@�ӂ���J�LX&4&I����\�]��A���q<W����v��?J�t���ߪ�eݾ�������ȗBP{�9���Z2�"��4j��p�=;d���X�� �j���rz�ZW�zъ3<��h������BJ�{�r�B����a�o&:-p�`�|7>��%_�"T�	I�iy��-޷�s�����JYF3_�_𓚨\���;�I��)��%�q���ѱ�W{'EIhI���H,I��M5Z�۪�@~�K�B����)�t�3���$�Sʌvɱ�i�N:.�0�6s��tĀ�� m�� ��2���g����'[��<����X�/���e��V��s_J�-?���Nb�`D9�`1��8��S5��ɀ�ؤB2��z�_D,�Y����SD>=j��0`#Fo��F ��(>x/�c�|{	� �զ�K:��"���Pa<����&�|я��r���
�Y1�2j����_�`�%��@�OM��z3�	$��ަ�޼ ij\�.�*7=����|cVDQ�y&�����dH�^k�c8�%����U����Cy��ɃU2���nn���K���_?� )���}W�T��T�>��r���>:�_�j��a��A�Cc�Ww�g)��_�����B��'�FB�y�`�?UBr��\\��	kR�{��*��ghn��Z�_��h,q�����u
�|���l���1��5�QU�1�y7��vۥ��ū��ͭF6���j9s�_�%����?��]�؜�E<�_���P����0g��F��
pʬ�=���ۑ�R�=_l?���?��L�Z��M�ԐFWI���]<����L3L� Wznh�UV��=�3u+)����.ૃN>(Š�2!��7����}�R�?miB��4J)�]@Ã�{qV ����$�x' ����v���]�e(�V�^���VY�ZN����v���w���C���_U���p
�S��_i�i~Y�#䬌�B�h���8����@2geH#�Ҋ�˳X~)$,¾erA���
�L��r����A{K㤇W��>�3�����Tʉ2`��Ӏ@OM�@MI����1m���*�S Z���b	�i�����'*Z�Z}}4�M>�){���*
h�i8y'�h�LV������5�}G��ٵ98��\u�/ׂΟ�\n7�:+���M����`�p��(u-�V�������@�HnV��;:%���'��|�ZBx6��Z���gX�:�]����#.�|T��gE�;��*c�IN�5��p{l�F�MeAa'Qʎ��AW<2,��/_3��_�C���s+��փH�]������&N���<�Xv�%O�C���6�0#|��(�'��>��A6ς3E-o�ċ�s����T�\���Wv�x_��څ�;�@5�yX�r��S�:�J3�o�:��q����<O7}��S�Ǜ��<R�CE%����`)G��|��h_I''),"i�Ӭ
�PѦ����F׏G�[~d2bb"�=�QO_r��b�fE^��|��E'A��3!.ΊBdtEi�v�f�`v��r 1*������ݎ�}-a��L<��F�k۲"pӏ㪃��N5���u�sm�H�p�~���m<�$R��s�:%dQV4�XiԂ۔;�R�M�CAz^}_,�hP�=C��&D�y�#�oC��7�-&�?m�{|���HAQ�����O]K�d!e1���p+5n�	l?��ǭ��߀z�|�)��E%�s{�|��� �-ze>0��"�������'1�!�Q��ߴ�	���h���4#7q�]$�����b�e�z��S�{�PG�g/��/�y>зk��Y�������tРL0�5�!x�M�Gu_�����B�;Ωs`M Fi]=�<��lC� ��/Ps��w�^Ӑ����v�OSO�\��KH.)5�!L�H�r�&kH����u�#�֎Q����@#78,Tk/��R�T]	����=�@�Rk��T�����g�{���(,x�;2HM��6�3T2�Fk���c�~�+�����0�w�@�hz?/E�	Q�E/{�=��tl\��t�0I�o6�aAZI�j���Ēm#�Q�O[l�i    ��H�[�ǝa[J���}'i��@�6?��h�=��9Ij��_\��`���E,3�"��kw��`-U0n4��Y��fϝ��ܥ[<yg��a�����U�MC0v��(�⢓eX�D&r@�����<��G��͓�$9�(�;L����O��,�,�N�=�]��k����
i�	��ɷ�=
!Pp��9�����N4��f�\9yҷw� 4�Ù��L��:��<�l�3��~�o�n��[Vk�qu���j��4U�9�	{ �Wƺ�Av�&�x�恐�L��S(/�q�8�P*�v��ݟ���V':j�a���蓘N�M���k�~���~�^�ob��z^PxӘ�Š��N�wb�8WF
��M� �|{+�X}^�g�O�iZ���q3�+cj��w���C���_Uه�{8�ީ��t��4����0ޔ�F��x�Ex�7���X���ڜk�ج8����`\�� �$��;�@�R�;b\惲��(��
�����e��{v��z6F(��l�Q�Y�m�9.3񜘞�`��"/$J�Yc���\��Jb�/�.�%3���{�	���}�Z�E���A��/2�e�7�P&����z�WR?�	o�>^�-�Pq�D�3�뛛x6�s�9u�ot��\>����G��+�5}�+i�!Y��[��VX��'-�O!|rK{��6T�\�R�jos���m�F��:��,.ʢȄ���"��_���Ș%D�?��ǰ��z�w?�7Ȉ�3��R�1��2'��-b�iC�
��!Nl�k���U�2��\��I,�X��/�!X�ҕ�Fy���M�P 2�4�(��U���dl�P��ͨO8�L7�yu/pm7 ����֖f��.�O�&
CռEyd�}�t(N`��x��*P+U��6?rs�!V2��=����k�/~���*��h�J�^|�&�lu�E�F4�í���! ��T��ha-��[Q�a��qe(�3�Ѐ���A2�s��cD���)x���Xdr��S�Y�<[[D��X|������2�xT�H�h�7S��a��ǵ��rc����w٭�V�=߷���E�A|P+���=�\O��4ܙ�π>�Ly�%�Qy�!g�$PL<���*o�"P�n1�U�^�b�(��2��i�$q�	�4���$sC�'�&�ޓ�$�B<��&Xqo������=Yd��U'�}�B$��3�$r/�[RG��Hcko	O��4�͊T�*�9��c�|�f�#�Q��-����Su�o�8���69N������$��哯��ێͻ��C�A�����X9\��R�D0�["�<��E7� �=/��E��_ﬗ�_��xhp��"�2{��D�H
5��J���϶|%�dM����O�=v�S9<
��j���sp��z���Y���8
>�ذՙF2Q5�j�_Bg������cnyI�<��$-�x�x�6�s	�WN؉�혤�v״�W3�|l�%H��
$Z����.�{p�.��fv����[w�5Y��Ue�c� ���+��г���������f%[G[C�+j�˼�}� ���6I�<�t3�jCs�l6oL/�a�l���C.�SC\�]"����$O*S$�m����z�Z5*x�ʄ��U�D��<�5ɀaM��ud�R��["�T_mOx[�]h@S�yg}p��&�����䶆�_�h�#\ˎ;j8�A��?�Տ�y�+F�\��\�J{g=��b�x���`��Y��ݼo�Z�
1���6)ON\����5|�? VU7�r.�4F�A`���>�� Sr��X�Ep��-��u  �O�J`iŜ��r
���uͪ��E����g�v�ةP�ݠ`��0Jp�:���䍞��c��K�|�Ԥ�! bP�L��zBd�Kh��� W�|�qs�(,�����	�W���:��c�D}�,!=�D��`-pD�x�9��x ��E���Qf��Q}u,Y�&��YO"�挻D�5�D~-x�)b�C�cl]焸�'S��j�ɿ�4i�<9��hj�ǳk2����H�;b�V��k^�J�0��>םw>}�j�UAy��v�6o7���!��J��u!����%�Bi�,�G�F�*|����ڱ>cu�"6<�mɴ��*?H]I��&�hS?�D�����;�R#=�Fx�:B��(�Q&��YO͐�,�/a܇;�J��6���fRw��@��}7��8�:�$�x���#���'�5��ŔG/���y����3�zx��r��,���o�ϻ�lE� ������v�m�-'��Ib�\��Q{�%�-JF�6��b(=�H2d�a�zQ�db|6��34��3b^�DQ &Gp�׳e8{��H[$T*Ŗ�^�|IW�{Ϟ/�"čc&`r�1�`��� �G�;E�=b8�A����8<a���Bȣ�fݏK��� WG��pl1�"������@¤J%]y�1��T	���Sy�W�%*O�0�:Z����J}��y�"E;�8��ܶ2/uxW9|u~�gr�^o����R����P��v�[%ݛ���OF����0.�{��j���/W���7��Đ���a~���D����[=uh�׫��*񦊎��nW��r`���k��|3YD�05@'V����I�:"�O=��㦖-?9���(�y����A^�"+���Bd�yo���u�Ӝ��ov�*�l�o���C,����;HD�䜳��{p���͉��"�>$V��GL8Z�F��"������.k���e��V��:U?�ת�_W��6���;�o���{'�����5�	�Cs�b�b95��s�:�(Y�Nw%X7�E=�m��^��X	b�=�՞To�6q}4m�*E=���%0v
k�3Ԋ�ώoJ��� O�&�� "�S�`����z3���x��''}�Ag0��104����%kD)D2��j�Z �OC�ŝ�N�C"��� �|xH8�^@3�$�ݮ����;�"�B"7�'��A���� *e*����u�����Y�P���T>�����F�K��M�������m�Z_����	F�n^tŰS��~��Ǚ�g��"�@�^vbE�x<�Xpb���ё	�ɐ,�S�C|і)��k6C2͉���f�Y��� $N!�i�+XI�R7���~� pUc�P��C�m5���=bczL״�~ �\Aĉ%΢��0�^������j�YT����+%vt�;�:P[�׎x���Ì��Ƌ�'���D(�K��E!�Sy�Q�qK
��Ս#d"R�yܻ(������E�N��j�ȟ�G�z3?�ܾ|�R�e��'�T�K��"��EG���E)ƙ���g�;#oIPŘ�-Q��%1:�*�q�&��҆r$<�c����E!�h����#�w�ӻvU��_Ee�qQ��gŲ����<��`J90�C5{�#Fe>.{�zϊ^�5�jv�J=�򉈝��|��>2���>F��"$�Đ����ڑS1��+f�U��Iu�Vb�Wd�b2��\fΪ���v�RI�Ln�}8������z/$ &���qJ��
:��[�
uߪ:�Z3]����C�!�8��H��Y6g.x}0]�m��@���{>�A�3˙��jMt�OBB�J�=L]���ȡ��"N�|�����v�"$OL�	��a.=���w!�Q����A�s8j<0�\��v���>&6��Xҭ����"�wcf�I.�4$�'N�̂P��m.[���cWe^Hc<�B�]5���M�
�h&m�n�)�����~7�B���bTz��=x�`�"`�O2��jj��� <���v��D������/�?�:x���O0�P�Q�V}V�U~mFv�F��_�9�*��|=X���O���Ӈ[��_�;�v��L���뇯v���m����+a��7S1����ҷ:w9�]�}�.χ���9}�]��NL4"��j��O+pvs*n*��ǝ�il��	��5PC�a��ǘ+�2�F�t���;E�LJ�kwJOf���4<���8>��s�2q�RA����W~��+.    �R�[�jy=����tsG9��j5�6Ӎ���>�w?���f�O��`�Y�W�^��܎�� �P���<�E;:��3`����|�/X�'��� �fA�U��� h)�Q���Y�UVrS�ɏ��|/7��J����b}�x�kS=��v.W�ϰ�S lh}W��K�rN�����Q�!��}
>A�;��Nk������� ����ЉȜv�l����)�\�CyK�ql�g������M���V>���r�GJ�"�Ң3������?���6!����OLg�j�S;Lj|QR�;�qܮ[��q��u!����{>}�@ S�	ܭ�bt�������\�/��D{�l�D����M��.�8���Xςh,0�v�(�ٿرeM"��b�c+%�W�iCЙ��R����}H������n.�|t�Ed�5�O���;��%ORG,�����������!�MZ϶k�:pYD���i�'uHa��i<�י>�s�%�*��s�}#�,2�`�0��4b�X�f�߹�g�+���Q��R{�  ���0�m��+�@B���`����zEC��7�[�����5ᚎ�c+'H%��{���^�u�(��R�gr+�3�����,0��u���>sf"z�0����2�Bv&�SB��~'�(�Q��9U��9�����S'��S���L�y�6��;��{$V��Y=E�E�G��v���FAa�7A�+�m}�1���!�Q��1Ï�����x��[�2�hN0�	��]���pVֻ ��$W���,�v�Y�Ѫ�U�h�֋/���VW�p-%U�����+~٫�@����ǈ]Z$!�aM�?�H�WSA��@/W�]4V=i����(�T�r��0�!�)᪚�0�(.��u���`bѺgqi����Ȉ����
��).���z��{�}3hs��e�V�Ō�vv�z��5o�o5�B��g��M�Z�R����T�����m����IC-+˯�
B�m��/�⢓eQ��"�X�w�Kb��F'4��V�F�[�JfK
��j�a�.��whh���O�����§)?,e��d&;6�[UةW�գ�b�:��Ϧ�R��M�gj�^9�.��<8wa�+<��.�b�ըE�1�M�4��1Z�fىG�/���� �Fi�1~]�#'"��Z���O�����U	�j���t�M����_,�@U�����uD��8A��p��-�*6��ӣ<Lv&���G��6-�q����
�Bi����'6N&Oq�~��]Qt{�#ze�W
�� �QfQL��	�J�ޔ|����(�0����Ŭ�G���#��xIo�JL�TtDR�K5ٗ�6����<�P6�֠���'�=7���m�S*])ƍ n��SU�SPs�~$`Gw4�s�*��Z��F^�L�'C]��NR�K�|���B�+r,Q���*Ί޸���&�z���|�g\���}>� Yf\�����D�f	d��T�&�RJ3M������P���3c�&�d=W��8��>���c0��\ ��g�Ɔ/Kb��ч
�<�� HZ��M�8Y����@{��K��-��F]���l�O�S]?����2c��1��p��$��}�a�)�P������ڷ�f��'ļ�5�ZoǸ����ɵ'v�>�桒��y��Z(hF ���zw�AY�ʁ�D���<��}9�`6g��k5�,�@����d<��PE��2)�WI>Nba熨-���aj[$X�S,���g�Rڥ���W1��|X�����M��"�J�bd�y��郺��XB��5���ۓ!�5���KS ���o�-8��,xp�i�
6A�p�畄�g�O_}p?��+#������;�L�=9���g��|��{Lm����JlҎN���/��f��LI�K�_�=^����r5j*�B����g�1*�����dW[E�0y��s����z6��r=�/�*e���.6�t1Q��Q8'?����z�&�/��\f��n��1ނF��!�<�D^m�pJw$�}�`�����0�l��4�e��w[��0�w� �Ul� �_���Q2ɕ	����n>T�����������8�T,Gd*�ؽqf�P���݋��:��袉����	ZR�O��b���h6���]��S��ou�&�$�i��#恤�g�薛p���y>�W�N �@�C|1	C��@!����c�d��yR�>�		h��#WN��?k�%�sź�w����x�ffsrS| Y=�7Os6f�rD�眇i�đ�	�oZI긟z�
�8���0���fE(��y8�梛;bX��e�]����#���$Y:���^�">�Y�M�$?��m(Q�'�k`L�wDQ��R�e�ʘ��s�2�� O�6J�#9˹0j>F�x,/�݂őC�4�Y>ɉ�s�E��Lk
չ�\�\4V�� �wؼ1^���/�vz�Sb=���'�ԿdE����?����ܮS����o���<eG�3�>-�#1���Lj�Z���U�Y���8:�(��rB#6�n1�-����+dd���e��:]k4�n�������H���xw����t>^r&gp��� �~\]*>��j[m��F�?҉�@C�-�AKw��\�0�]ZO���j�ɂ�	ο鸇o�N��;���P�h�V9��U�}��k���s+s"��?�˂�3�t����j�4�����LQf&zK�Z_��ܪ��C�\0�Q�ƙ��A֐9��+7��Ҷ�H \�aB?U��"����㳿:|Ã8$DeF���[3�!3y��<���	����/,<d"s@�E;�-\3����	 �<Ͻ0=�.N+I��N�����ƛa�b�����Or��O���d�����)�� ��`#���n	p6l�}�q?S�[�5�\�f������W�~/L��^v�4)� 0fu��ݓ��՛��h*��"x9�erWQ��Qݼ��N!����{��GgE��������2D��S̚��ڜMٰ���l����mrt%��	�$�0���	�Nu<\2��:
Ͱe��締}	n�h�A�z�`V&�[�[)"�d(��;Z'3y���ީ$"'y�?Rhii^�$8D���ZU�64�L+��w�.J]�J8�j�y0�C��<�N���f�˽���2��U)���lw*�n6����g��4����:�����X�3�1"\��|Z i�D�f�j�)�$��XOM��s�>��C��{�KՑ�{K�X#�X�Qb�{JQ@�~�(���#���hp���H�FfyRf�g�HIR�H�79J�i��QRwߢ����Ɖ��nG�w2���G)�o���
�3�B���>[�8
2��oC�H-A�9�.[l�BrW�j3�$󌊦���D#"����8��n0�<��O^���y���<���$��xH*�UE�Z���(易Q	����\%u����$uǜ�)&4jM<~�)�\<����J���@a?ԧ��^���`x!�Q��FA[Rɛ���J 	a�P1mM��F;��jF�#Y�b|�#]���q���P�z]��_�� �m�=R��jDV-��8�����Ã�ܐir���B[5��m?8V��o����޻-7r#[�ץ����!څ*k_���v��Cǈ��sI��wK����G��^�{��I~$��I�Le	$Xtt��-����\��J�bӑB��A�7^c, 9+�pQ����e9���a�m/��t�y8�em=?l�}%���z7}���\/�[����wcu.�UC����9F�����/rQ.�n�T8�?Wy���_��xH��7N�� 2��z�mS�������@l�(;aOz湒�`�D�ոzF�q�� �W5))nX�"�� q�x��PX;��89e�Q6V���ד�3ss�Wȷ��<�:9,��3��.͂��4Q'�����J߂A�i�}Į은��z/�[��W����,�Ǭq�8b3��^�����Y��j�4��(&��OV�:C�l4��Y]znm��c�"�paA!�S18����6���8��KQ.��l    ���Ǚ\0��e����&������
�W�8/g�'x'<̲	��d0�N~ { V�y�a�m����ߋ�y�6�֝h����j��358��M$A��6��>&��;�#0b˱$ϲQ'�wD7ͳ�+J!!�U�%Χ/��%t�S�mS� ��y1����Ɵa[w;"�^�ee���<Yv����m�t�nR��}��h�6�6>�Q�1�+Ѫ�?e6���m����a�mؤ��>�	�ao��K�NQ��YW}sv�m��㟵��>"`ޠ磺�L��g�&JSPy�3/TY
��kiRQ<�������"U��3K�Q��1L��`�J�+�'u&í"�u�q�*�'�,g�7��EB��V*-g�gݘ.}m͋�I�Y` ��)ד,�A�&Bt��^�P���Vai3I��xs�r�u"��]�3~�жK|�; 5���E��J1,��Dd��zER�I��A��03g��Y���ard=1��'Ǘ��(�����8�5���d~v�/��mP�K�?�ݢ�U�sך8T};�E�b�ceM]��<U���Zƿn�K�D	�Hu����V�uϸ�D�뢲�"}��+�u�r�h��{S���
X{E#�NvQǠv�ss�P� �.*$�l���}3��)�*��!����c���kg��t��B��4���v���X+*�<r��x_�v�h��D'�٠�D������/
o�W�^�@�ˤՍ�؋2�?�5�GCf��t�A�"� �R^��e��jLj���3^�S�������s�|�b��_�N2�&���)����,�2W��\5O ��aW�I*C����V���K:��O�����\�qO#:��B]�я�)��Aʅ�i�� �������
���	�����>�^LA���B���4�gZ:�$���ë0s6���&�\nh�T�җ@�ٶ�Ԫ^ ����L:�+���v�lm��2��/L�ޭ ���n�4S�kW�q.R�[/���Ow��^Ce�d�`R���Ҥ��|!�(O��G3���w�^�!���}i(d[��Z���۶��N�u���tiS��s��	�G?RL�A_�\�u·����!v��<��O�PW3�y��9E��-A}�(R��).FafG�t{j�b�����T>�֕3C�G�ŀ���v-��+\yQ��2���F]��;{ /�s0svr�b� �b
���}Y��A���U�/�q}+���_O�	�$��o�)A<
�(c��t�q\�{���tiČ��:�wv���f1���>��:�t�X��5d�
�PɿnE���wr�Y�����Lw��b�J�L}t�ĀlX]�������P2���0���ރ=n����*��d��{�J�]k�d�_�Ü���;�N�&�+��%�N�m���?Na�|�zc��2�ӷXV�o(�ތ @#�->��p'�3ޘ����o��B^�8 
�NV�D�@�i�:x	�C��R��y�RZ.�,^z���V� ��Wc�FX��62aQ�4��O˧�\�2�ʚ�uP�Z���D�e�-�L�������I]���E�E�����x�$�Zή�p���e�Eٕ�|�l�D�)�mp�H3?A*�u�[FU7*����m����"QW��� ���s_g^��ef�v9T�u����<���h�\ni`AX��%s�ojC4�f��W��c�Ծx��=�cK��*G���ӑ��b�d1�]�j�>a���+`ٶf��N~Uc�Υ��Ǧ><�>�ASnib�b\�cf�K�v	L����С�FL�Xwov�&�Ԥ���{�!��|���O�|�Ă��:�/k�E'��|���<��a�e�Z�� �gc��E�O�ɌƐ+��E�w+F}s�Rt�A'+�,/�A���eWy��ХVM�����(P�1�����X5>����[
�E��������ٱ_h���eY��d?���|[�țb� R	!`2\oPvG��d&�W|ʛ��RY�6������4��@�,ky��Os݉��e?����Jbb'�ƣ��ݹ�K�V^{��q(d�-`�p�wJu`���}� 0%�u���2mS�0�m�4M���(݃n=&��F�:��08�xaz Yn]���]6 `�'����d9:Hhbir����W��;��W�uh�d���ɇjō��0b(Wܐ 	�	�;�&T�glr�XtEP5�W�?�Ͳ��R�)���<M�*-�Fg�O ��ߋ���Ķ����_ձ�J��J�׏*"���y4y��ۑ�,Vb��㜍��K5�#(ӤrU�g2�ES��{UJvl�e���(���s����.��u�$�g� _7����V ��b�@��ia:�h��z=�1�w;��s{��;`���l���"����z�X�6�Q�R�t�]b��b"�\�F�Y���K�yrPV��� ;t���r���ծ/>4��@�x�Z=��<��U�y�nH`��1�-.x*T vȓD���Å�d�{�����ᨓu;y7ͳR�e>LD6�����p=8mr�ğ]2{ٶStؗ���n��@��#ߵ��,�,����g�ϓ��J�ӟw�T��N��tE�\Ϳ�]O�2W��� ���AP�&L��)�J��qA�"P<��;Q�L�淡m���[H���7��/c����v�Lh a5�O�C��0����56��m�q�O��c�b��P٩�ˌj�W"m`�QG�R1(�^)@�ܻ�Yb�'MZ�:_mj���w�>V��7��ػ�g(�f b�Yo�w�S��[A%�j�BQ��#�)�������I���KXCY'�u�,�Fe����\C�\C"�ف��EC���6��/�ؔZ��fOy�U3��X*^�""�ڟ��ק��|:}P�W�#(�z��1 �E�G`���q��A ;Ӆח����������7�5F0�'�$U��*���˩نS��#��Ńȗ�;ŏ���[�6
fai�v��q�v�~��R����zW�(k�@������{N�4���Tz���N���xL��d[�7�U���9�);��S��̙1g H�)�m�i�yB���2Xv�Pl<��z�E��E�L-���A�³���;�851��@�����@�{��&�z����:t��^,��Wm|�m�ԽnǋU�z5��m����T�5H�+����Gh;�7t��T� U}]e��k�`{�h�!�5�]�X�V��(�O�$�'��8یqfM(,P�LUi���s����\�n��Ĉ�
�}��������+�ӥNr��i��1m�r&����iDJV�$e��g	7�e���4��#n�!%���v�}Lk�R$D�ۃ�ʣ"�ڥ�(p,�`�e�X�4+`�����b$�|��9�1HFښB��x�Hȋ���}Ŋ�ʾ�%F�7��&ܐ:��U���W\&=%=i�b�z�.�T�R�l9�a��znѧ���s����L<� �s�0|�vQ���ǎ�p�ҕF-�K�3��ڸ�MT�Jܭ5��┈&V�$y�YX��
�(�]�+7��O��,�2$�������rb�;t�9	�����p��Zo:;�v��PZ~t>y?{x�խ%2�q�WTkσ�������c?����[4Û=v���T\�^'+:� ͋��9p��W�(O��f�\�P-��%�c�nlXR�G������->t��+�k�̄kA�����'^���啯f���5�J�$G�g�T'��{~2�d���b�ڂq�X)/9��O˧�\�2v<�O(�/�wx���y%^�Mՠdh��}%1�ԪG�:��pR�M+�<��@fP}X�w�#!y����I�a]��T����cf�q?t/7�?���?��W��ri�f�Ku�h�T��F�ꢁ�(��Oj�c]�2���]le�n�~/�=)HƗP8�85F��TW��d[�����v�t����@�{��,�^X!�B�%�n6O�K��k�� q��G�OJ���|�X�r �R���j���˻���*2�5�>sk��D�أ�Z�y��B6�T���    )-�K�5����(h�B3�sa{����߈A*D�-��0ë|�'xԾ^����_�gB��x�7kϵ}�ey�w.�bE����M4 �j�ą��L���IF��&n��� ���6�Pi�,�e&3Ҭ+S�"��Yչ�1gdd�(�&�~8�rt�d�#ʤ,�hf��]��\�9�+|O%�l�;����\_�d�w�C����v8��c���w���@M�`%�"v����� ��o`,�V@F���I�%��f��Y���V�a��������/��+�E�9���=�Xr��aW�#X.��*J��\�����6�!š��0���zrvz�������/��2����R9r��z���������E�Ez���ݛ5Z��;ya�牉�~w^}��]����O��n�gZ,\\�n� 99x �Ō*<{ё�/�L��
���D�d��#�
�+���.�wp��,`R��aRO�����\7�%��Ƒ�<�?�V{�"���{'K�;t��6!���F�Wi�Q絉�Gp�z��eȯ�o�6�2<>M��dN.�/��0���푘�ю��'�e\퀚^^���&��3Y��f��b\k:�;gr@mN.��a�	ǳ��ۙ|%s�|e�c��R�^j[}Z�vE%�"�4(2]SI�B����mTx1j e6)�|���D�3g�xu29���R6�o�Xט�"{�!hA�5s�hh���PbK6g���1���DcZi̔�	��
��C�9�'��:k��M���`@?g5��J����^Vf�D��*���Ή���2���ɳ"������&f��Fw`k�.��a'(����Ƴ��o��o|_o@.����TdVMY��[��w�6z p��M����8�5	�MX㣸!0�=y�Q6�|�l�U����НvY-Đ�9,����W:A��f�B
�#O%����aQ|m(��޴ʣNz+��kDmQ�3�76_t4ig'&:ZA�/��lљ�|�e>�*�e�p���ς��m��C6�t�i������`�sM,��/r^Ł�x���Iz;Y�^�d_p��uB�	[��z���YU� 
楇`XE�$��@� �����eW�`���ʄ�1���W���ÈNx�������b]�#p�sC�,���+�J5L(��W�<� J۰�>��d|t�*�ޚ��s�}�!��;ۨN�ìA��DXFYd�B��J��+��]�wWŨH\����?�Uk��6�	"�5�N[A��1L�~���5���A�;cɶ�R����hO���h��w��� �@ԇ�T�ϟ.�c_V՗r� ������d�b궯%��>�%ֶ3wi�D��j�v��Y'KOcLlY��[¸�����fos��ƴJ{�C�f��+ ��r	��ra���� �[C�O�������*�,B���P�K[�L�W�"bp�	j�4���ȎB��6)R�d�����d��ҠC;�D;��T�}�Ua��!����y�vJ���SIҊ�+�r6�
E�"Z�Ȕ�-g�?#=��+A��O	\��z@�z��1U@�/��X� �]=k|@_���u4�k�������kاU6��_i���ۧ�SG^��/2�y]�_��ͦ�����^Ou��@m%�~����++əX,Vo�08�C�����m{���i2q����p#nl�e�J�6۞�:��������x���� ����^�3��Ɍ�Q��:Q�B ���؆�f��/�E�piX�uat�Z�٠�T?�����D> �ۤ�〺�����5��f���f��w� �	h��CnPqs]�$�7���S*�� T$����H��4��nV�]�������Z��%RB�ҁ�4�c���̙ཫ#��<s/*ĩk�"jv�kL�RS��mޙ�'���(�ZRp�����/���X�)k~h�.)�s�J%oǨ�86�b��D�m�0cq����&��`������!��Y�Z{Ҵ5��,Q)��v�X����vp~��.K��>Yu]EB��K5�]�� �F%�,T�h��~3o��-*�'d���Q������ 
���4Ŗ�t�u�	��������nY��2!�2��AB贸t�<{��֍���@xӻW�K�=��TW�uS� ,Q1m����G�_pz���{ӆ{-�r7�ڙt>ثm˨Q�M@'h�p���^�Ը5�m�#3j��@�i}~�%����b9��n����2�Wq�`���d&��%��`��t��Zm��Y�����f��*���Gj��^�k�+B0K�I;Z��9�<'G�t̔'z��!��B3
� 8�~#�?�rK8n_�$7��m���ԧ"FƵ{�Q�e6/h�s=�L�'��bT��D�>O����1�2|s&����':ڈ>6�\5�4�7a�[]����FZQ���Ut2�E�E�&"���&Yū����i�*����qd[��b��cQ�dG��㣈ľZÕ0�|�� ��o� �	|��ƲR#=��"�~���L�һ^�������5u �_$L	��6i�#q�����l;;M6ӈ&�'l��: �����(z�T���%1b�뾹����
?�i �[������gh��/U��F�O�q"�cާBj�܊Z�����~�˷}�\�����'�u��jr'V=������S�_z��VK�x�?�c�o��+�ZH�)e��+4����틦�v���ஶ�O�����i�?��O��k��]�:+_��L��(����\��/3���֛U��Epٞ�n��9?}q���ñ5����*;A=�uJ��P\�L	��qe�ؤI�b �}Ёp��y�������C6� ś���0�n�.FuZ}������
X/��y�^�Q�P���m(�lv���y��,;�4DȬ|������9��՝d�U�k/��>a��G�DA�H|�k�[����qn��� )j��D�S.�vdF&��7T�rYv����j��(��L����n߂�� !aO��
S�sw�إ�M��`�!����諫޳���6������w�G�Y2����[>뭏�N�Va@���+`��>��@/A&#���?�T��+3B��=�}�0eP~�t}���e�9�+�JD���B��/V]��L��M�����!��K|��o��ц��Im��k�ŴLW��y��� A?ɛ�:�X�Ѿ/kզ�wt'�b-����7=ȕ���bc9Ji�:��pL:~}]_J�P�[���@�1@q�j�Y������|8L���V��T_]^���Y�2ʘ�F��?_�x�B Y��D�C����fo��q�m3�S�bǱ���r6L���' 3�>�%��6͔�'��[���D�hp�)�̟ ����Pj�ظy�c}^,�>_֋���K��	҆��tὮܖoQ5ھ��{
Y�u��w��#e�i���d��B��ᄌ�$T2�}{��/"���O�H�qKv8�����3qFj4B�Z����pFa��K�������#hb��O�c�Ӆ�M`}��՞[O>�L3K?A�9.6����dt�X������bf�űmoVǇJu�O����ؑ�'�����Å�v|8^�� aqW��z_:.��~�IA�I��b���q�M�1�\��)�Ǧ����t�������|0�����O�l����6wo�������Q��]c3PoŒ=;�����Gfw�H��������=v�I�� �x����:E����e�K��^��Qb+[u��ߚoEm�,���0�f�y�W���5��p�K��'y�%!���$��J�q��7sV~��hEbὙ��̦����РX>;:�h�h�� 3S�F����QX������<��R�b����,���_]�~�3�7韸�����È�joWY�F�,bۋ���#C��NU�P�"!a߁�Y}��N<r=�qv���f=#����U>���B�Z���⬍1Zdb���MY��fX�5V��� �*�q�*��?�=E��z(z
��<�Y%ќ}!����v5嚬�P>t�hVz[Tʏ�-    7VB�@^",�vl�ck����Bv[�}E��a��p�rƪD^�1(��P��O�˺[�dpzZ.�[хM�=�8H��Ѫ>hTm��j&���=�~Z�S����^��Qe����M.�6�n?ȴ��JfB�ZX��(�o�ߨy����{�����/���.��_���V���]�dU���ͻ��9�a�VT���飚M�R�w]�X讘F����gogr����=�a�8|y+Eǻ<+~6�]��ճaG��ϩ藢HDֽ*�,!��6t:;&��C4�1^Q]HjBj�ޒmi���0@n`@S�!.������-�rD�����뵂�Z�Aȡ�JԬ�:y��QY��xF=��m&�R��z�ԉ�J[�ɥ'kJ��<�K����R��~��O�߿��*�h#�>�3��>-�:2�>��^|��P��Q���K
.7�z9h��'���1
���ʧcQoa�� �c/f�Y��׾lPNg�)f�DT�#I�vE�N����3��ۯ@TM�W����)�j� ��������Ԟ&���0��~����H�y���d�/��ً%(��uŧ�&J��^6)��4da%j֘����ٰ�&�@G}H?��>Y|K6�x,?ܖ��"O�$��4G���s�Ü�eh8h}���Z]�(���� ͥ�}r��]��|���RdeW(�y��D��������Z�FU���xd|�`�2�|���A�{1�EA��X8�Y�"p`Q�����x~t(Q߀�A�.8�Z���p����{mt�0ۋ�J'���� ��a�� �ww�g��=�"w�2y�c]G\ʐ)+��������}uS�@��E��V��W�6^]$��)����`7�+����ľ�� {���^�
���5s~7�ܙ�h�W0r"p���z,�'a]�$���'T�c/Pv�T���������2X�F;�1���`�]t���4��lT�a"DvUd���	��g)ry���&��e�7Ʊ����ɦ��.3ؘ�6���q�80����6u�I;V�ܛ[�R���$0�k�����'<i����- -*�vq�)��ǿ��ޡí�R �~�ku��濯�����_����NpW����؎�h�Y�<�XSk���rS�s�:���a��iҝJ.�D�b�z2�Y���	[ߤ{1�3����1�\�`��o�E]�O#@ׯ!��<��G�Ud}3���7������[�L��ng�z{p�aj���0C`��vS���L�a3o�?�`����]$�G���𭻨�y!k�k�}��/,W ��L���ɯu8�t-[_��۶A�E,4 |p���d���?B`ahu�]3a���5�G�	y���e�嶺�|�u�tc6����L�r�Ha���c�@m~��>�� 4~g|��5]M[�%���0�HŰ�ee�/��Ⱥ�u�����I���i�P`ϱ���0Q���\���R�&��~����*������������������<�k�X;e}`�ݲ 6�P�^�B�j��N�����P_������n�Kã<ͦ��ɟ\��$���&Ls�Q��&�>V~"��X�]��� �b�83p�NI��ܒ��-��`��h~��2�>��ex�-:s��8���p3C���W�U�f�M3�,���:"���4�]Qv�ȄC�}�ե �r���x1��� <;S<ӎ�'����Xs�F2�,��7é�E��k�ηvф]wYL��G�lX�d�6Ґ� q_d���Ȇ{`�4a<���)m � �g�[
Ib����Ϛ�Lt����,�e�Ɋ/�!l�8oI���snȆ�cxf�T�4�j
�36.��v�/��q'��XM�&'l��0��a?�3�PW����I�iҤ����9uS��kl����tp8�H
}5�����'�c �P(���:6�w(�P������x3������(�\�y��E�Pय@�R���rTEA��֗ޖdA8p(L��\�ħ�c���n;Ez#�N6��E*2��v�1���1�M�Я���dB��HȻS�'�Xe��$+T+շb��iʠN�%h"�����Iݘ���%+��������lYn��0�V�:"�d���bX�n��^�L����5�u6ut���Z�o1�t�>��?�u��IW�|���j��Iʂ&�lK�üg�4y��}��PL_����}�nf^�w\~�H3lm8wv���$�{c�
/n���%	g����	�W������V�������L|�Y޸����{�����_O��Oy��V$�G�����Z*sڅ���&��J�cOcB�3X��	ڶ\a��W�$��j�ڟՊb�v@;�z1Rw���UU�G�:٨#�`)��'B�
��z��Op5l�
��n��;�ʣl��|��ʸ�c$�Ʀ/�@�[�&Z2�9�=H(���������#ˡ�����:y��z�9�(�s[7Z1����b��e���|Pa'u�a�}FИ��g��B�Y���|2�a_�B��!G/6�{1V�ZZ��[!����<V�����M򪖍I��� �����t�5[?l[�
��Vg몺׻Ef�ϦN�:|� ������\^�c5���*p?�C|�^���vW�T��*A�|@U��Qn��;�	3���H�'��B�yV
�ѽ*� ���O��ַ�L�
&�2vv�H���x��x�&(��`�E_m� *4OS@���aV�y&��u�z3�L�48I�f�,�[�[rkb��/�۬ce�(�	�{��E���Zi���޸��1��R����ك�&MSI��AK�յ�S��ej��z�*��FU?
����ˢ>T�"s�U:�����J����5@Mn2ϩ��Q~o�N��mh�-��y	Q\b����4E�ٳ�:�<�-�m�t��c�>8 �U���us��H�&ˀ����j�z11��B��L��GA�k�Fg�^^l�i�UT�$��4:;�pX\k]ܘF?�C�PN�20!�E�)kh�úF-�������I��}5�\2�M�c)ߏ|�?�g�z#S�]�C7iUiZ��J�����4]�=�VɎ��u����
���0W��~<)]l�ɴ��w^v*��#�q �+:Y�#�4�(�^/��G~F����dY�{'uP���=<ڊ���ђd�+�H���t�IF��0o��ik��{���.�ʂ/��EzȖ|�f'ߩ��:I��S^��xcT�,؞廬�����ԨW�k�� X�:���FҲ��Y��h
�6��0�*��
<8�v)q���&�Y����g�X$���g�)QjQ
�*��<S���a
ߦ����௷U#@�_���IH�
:i�/_Ƕ��f@�[��Ry���eh:�w&c5L5�Q�*�����?���3����1S=��Rߩ��`X�)^�Jd`,l%(ܿ��F��<]xg�� �HhS䂤��+�rw�i���&��Mm`� �w����Y��,�ER�~���ȳ5�qb)����mzg����=�Ц���-g�U�\�uޤ�������+� �c\����e���pZQ+�N>HE^�Q��! �˓wPv}���O��U����þWAϼ��.�������V��=��h����q�.lM��v#�ʰ�fG��y��V�/x�]�e�y�|�l!P���s�����%���A��6T�9ؙ\:�d}P��t�;�U�H��EB ���bnw.��[���K��xօ�d�z��Þ߮i0���ANj��ʦT~(��r]눯���'�!����'�i~ B](��L9\6��hMo>�Jh'Z�V:�^-8ٻ�
�4H7t��ed����5GV>���0�3.dhێ�0�2�tb�vHӝ����߭`�åv��dq.õ��,N�9�7�oE��*Q�~�i�����?�[������y�aխ��~Q���ͻ��2ަC�QM�
�r1ݶ^'�a�|�W�ʻ�~��
t��<69.i˝���JU9P}.$��=G�,�tCt�G���4������A�8��    f��0?�,��	�-�k��Q���ti��͊Z�;�dt�a*Fe��y���j(��]��$�����ꆠX�	�Kv�v7�XnAT�L��X�f�=(���D�3k"�Ԓ�a��{M⢲���҅ݗ�=\����<+$�������lU���K,vC�@ ��O���ԍ�X�f\����v����78FU�n�V@��ۧ�SG.����y}��mEY���d��,��8˒�̡���KR�>��[yuY麊۟R9�r%�W�r�:�D�c֚��9���"�#�>�HNVlI�N�x��<�*�F�zm
z~O4�%�3�
����!_���(5(_@�ʢ��^�a���L�WwϏ�1�L<�L�,n����������z��=Z�Z�~*ze�-�B�9�0��'�Z���:��Q���3�22UK5�i�����S��>REYT����e��|���t$ݑ����p���q��.��濯�����_���o?��b��4�R������̝%�?
Pۑ���3���`��� �>�t`⹠FYh��^3��Y͍���A�4c�!3b|�����o����.�(W���>�n�AJ����Q��7�o>��	��W`� &��u��B���Uj����Օ�R[���|x>��Ά_�j#����o�p���f.��sҩ;�o�ea1)FW�\�s��KK�۹�<|Tg!�>!��ҩ��Y&�w6��e�\Q�`&��~�p��a\'�h�D��5�j�=a�S����O��ee����"�%N}�Iz�$k�:F'q��+|Zc������ӓ��IC��2�k69F�֐I ${�!��P@x  �Q �K���N�u\������E�Z�S�ڕ�(،@+�Wǌ����N.OƢ�v��(N�~��>ɩAH��b���VMA��� [2eX�_���A/uA��@����d��� 6R���}sT�+~��5z~a�z;�.6�����(X���H��梓���Ӭ(e��G���$D���R�%��JI��:ӏaW@��w�԰�2��Օ�Έ���czb��NX���_g�0�CŌ�����H*�j-7���7=�u�&#u90.�]�ۢ'�P�6��ĂR�z�^�m��#8�+L����{�=�F!�+u%��ʘ��[�qh1)�F�@��܁jV���G���o��<�t�¤>�7*�d��$',z���?���xbq���{Xg�h�wPw
�\�)�~b0S�d��v�MZ�T=[�v�9����?�����>��`��]W�z��C����m�к,V���&�8w���* �Ԭ�|2��-1��k����q���W~<�ΗL�W�
��^G���YV�D��'B�-�T��n{�S8��vw	cO.�|�����@v�����v=7v,KЃsSVs+E�ɳ4e���<쳾<�G	�*r���?��6*c��	����&_�l(�@��,��{U�z	��ʫj P.����5�YW���߆���4����k&�/��0����96+miؚ��,H��@+���&+{�6��][4!;��\|�.D�2>�M����J/�(�� �25[~��@�Cte��T{��	z��b�J�W����e���|˫�FQ.��B{Fb�|�o�RY�?/&P`:�&�o?�n�b�:x�$��9��x���*x�(f��?e6U'�	��U\�Ȝ[#��CΔ%���èZv�<ļ�Q5���� ��4Vzka��4���丵�D>hb�%�{t�6圙�m����!�/���`��uD�z7Y���0"�*�,!J���<��C���񪁤�Y�t�k����[Lg&���Z-��y-}�W5_tt����&:W�ֈ<�f��\�&ZX���������O�Љ+���u��t�#���O�r8q:��������ǿ��P�ߢ�R�+�v�U����n��:�1�N��En����C�� ��9��T4V�X6m9�~Yg[;"�M�^ �
?�.d�:�@�IE�,E��RB$�V}�j��C�lJxq��%��6X+U�1�8`�a�a4/�{�&*\��Ju��y�l�������s��tbJj�k��v��'�5[j<���뿷��d�m�����'>��Z��P;��\�8ѪB)=(&A�>���Z����'�O*`)�<�_T�G���^T&*�tv��s�}��[�p��p���1:{R%a�����G<�*��ې%b�:Uʆ��K��n�#(bvǫ���s#�:��S�Ɇi�-��2����"���ڀ����Y2DE#�9��($�y�I����mY)�M>оrE�ԥ�#Fo��5��r��)�Y��T)��a�q��,��g�X�����T2z�Q�Qö�y�QDA%�'Z��4~�z�O��P�n@�Q}�nx�n�|p�����/<f�-
��y� 2E��a��^Ug��bwUÓ�� �ȯ�I�p�-G����'�ؖ� P�%HT+�D
�N@^s␑Ȟ���xE+��*�w�'��D�"͊�(�n���UQt*O곓�aM�M���۝�'��4
��3p�(5"|Z���:��m�Y�3b
+[Oi���#���Փ� Y�N���̳\��=~�O����!I�̶�0M<��u����	h}��j����	rn-�~Z4y���<��ts�sv���x�1� �[Qӽ�v�<�	�<y����cz�ӥ�HT]{�l^Ϳ F<]�|f58�5�WK>	����L�i)���~
��n"j]q��v�c*,K�W�@C$]��|�_%��[��I�{) [�@EX'���[~�#�S����<sT$�M��k�Hi���Z2<���l�gwC��9,A�'�F^�����J��U3���C@�|��B�?��V���
�eW��$�s�Kd��"EgY��ē40�}!�6�T,�N�5b�9.�6���<��"x��/W�?w�F᠇�� �����BՇ�ũ�1}3�f��������n�味x�����}��[}���c�~�w���ͻ�l��/� u�#D'�S!J1*�J�^BV]�31�~���|y�D����j��j�A�͆� �2wINh���o�9�r�K{�n����R��ƴ�+���"��\�)��:��&5�z�e]�R�C�w��~��_�4�4�$+~yP z4���؁�����Ζ��TXU_g������D��l����(؛�v�k����5@fh�B>M ׾ޢ�pc��2u߶��|�˖+ϰ��4�JF���nE����2����h�h�^�����d7����q��?��\0�>�+U�z�5m$PP�M~|�nH��1��4]�R�OM��}#݃���t���l%�� +��Vp~�Ώ�F�K4�L�Ѡᅤ�+�Q'�bXvG��iט~BY�'�a���V�r�O����&�͹���j������5��w3 5���f@�v�C�T����L�:��r��#Q>*Y�|]�Z���d?,W�ͪ<�Ͷl�9��>UK_���]1nǜ+~(��v��xY^ɈV-7v�I��Z�eŧ#E8���I0����9-#�3��~\����ЍϑZ�3���j��e1�&t��x���#؝�(��q{�n��o)���N��b���ܬ������p>V�N�➳�Z6i�C�D^s޻<�]ݓ�$hi�u���v�zM�'X��hqB*}�/�*z[�^�~��,+E��v!�WE1Hh�UGC�K�c�<|��==U(q��8�s�y�짘b|�=�1eAT�F7jDK$�&�%�~o����1�}�$��$�,�
����K�&��z���������{�,R��tք]���/L��#my��H�:��d��()�|��Hmw��8��B�D�Q��:�w-!��ٹ�U�o�cm��H�퍛8VI�eC�=�a�˞2~ϳ��&n�uvsܠ���n����� ��sH�b6O� �7^��[
V';��w|�e��xm�Qx@^c��ǱC��7����wU�Wh��B:�W60Y��eoPv{    ��̇F		��*BU�$){�֥��4��s��ք��= 8�H�x A����?�MJ�=i���T��-�Q�,�#�z���K�#�y�N��"?�0���`����W�դ2Ч�u��r���/-��߭� �L������>���y34��!���#R����d��F�w4��W+�w:ЀT�w�Z6*�����NO�/l?{�*����fv�!��ɕ��ߠ9���q�S�o��w:�����0��7veH cw�&`��eg�YM쳾~t�rp�V�wrc��nz�Xt�[�DWE7Kl��S����Ƽ��@|_ǉ���0��<b�N֓R�q��)����<"q+7;�O�b�IG���\K-��*��Õ��i�je�X���8����Pv������۪�)�6a;0�7�`�gs�&+M��G��@`v��;�!y����T}�#�eM_k%��܋_&f����r;����&���/L�:����3�2�f���MY�|XG	Ơr(����k5m�Z�jۨ��.�G�#���a|N��n����S����z�N�;�� ������?e2�~Z=���Z�����y �|�6�����z��د�ɽ�=t2<Q� ��e�=�x<p�-�q>�ob̓6��8�j��@U�c��NVtD/�Rd��bxUtsE(rmk�x+^��s�NyC3��y�a��ab�úK�n�w�f�G��7a:�iL�bX�ұ��67�`����CoTS��^�uX�i*�өދ~P�U9���<��E�1�\<���9&-U��Ӧׯ]9���7�r�q�̾�eK3M��m����n�v��G튃�&�r�(�QQ���Y����d*'2*z���\��	����V�h�������aJQ��X�z����и���g�Q2�4+ʢW�\kLF����Ծ֘���$�
���S��nt���2)Aˋf:�na˒�uM���7n$Fg[��E�TE|�S�����hq���rnN/ȕO�����
/�� ?$���X.��E!%r!�`�2шj(t��(Q�X�ZY�o��|x�K9��Mf��Yo��	�;o�[�BO��'U<赱^><L��`[�d����2u��B�X1��d�=tk��N�}��yݙQѓ�&�⯇3��bs�<$48OT�� �F0���?����..7I�o������������r�Ka?��a��p��K�nl���a����%����F�p[v�"*LxM)	���1˿ܖ�,$�L6h�(W8TM$T+�s,8<o��N&`�� �gE��zWC1�!�,-�Z���a�J#w�Qk�
���w�#0��
��0�	��;X�|1�4h5}������Sp�"�;�?�e���>�`��h����
�
b��f'����V��>��Y{;��r�~Z���n+�a?W�i�=�}��N��8]��
۟�ς��Н�j�]�t4X$���tcmi5Ǣ���"�*{7@`+�P�,�i ���m�l�H�}fň:q �� ��;c�z?�Z�U� t=��;q�]�I��X��=xB�����A������Qި<��q�*�����T�7ׇX���V~V�
��R���	�)��Hg]�.�2&�"}�\�2���<C��e��~���e��nI>���F�KXv���Wf%�%6QD����f��Ԋ��b�mjꊮ���œyo�諙�o�j��f>
���^��Cw�� ��6� �D�e&!zW�<K��,������*zc���R���
D��f�ԟo������Ԓ�
��#q�����F*��8�b�UZ�����;ٞ��� :"�9 ��TT:;J*�� C��`�@�$���4��+�`�XY^��!x��1��A�sC�n��z��c�� M�d4"���;y4�Ȋ��R��`���EScW�>h����Z�� �l��JN�?��F˕|�2�Q�Q�>����Q��~I��y'�v�a�ge�[v���a.�x؉⊅Exi$-sEk���I�L��]����#e}^�4��,ډ��rն�ͻx���9��G�ͣ��:�ťIۅ���a�?.���f�8H�u4�E����zt��-k_�}w0S5�m�"v viL�/T���a�A�� m}�$.io�<؍0�5������|�ج� ���f�2/�b��,��y����f?�+��L8K��>��l2|��?��ȍ%Q�7�K���㱠�K}��^�ce�����=�A�T/؄'\���4��x��������p����׈����@��=<\���n��:�1�N��E�������8W�A5�S� *y�IG��H@�c��֮#L6������l����O5#՝W�#0e%7��|�S�~C^$K����DVϟf�~��R��M4o'��t��%�M56*s��v�5G����T��%".�{������o�ϸf��`�� snۮ9���h��uP��JI��&���@�|R"��w7������{_���P=�Kd��HE��ʢHDֿ*�EBa��J�U3Cc48s9>���N���OL*�,�O��"#:�ճ�t�}1Kx�P�K!^z8׋e~�e�q?5c*��@7�d#�'̀�Yf�D��̍�	��Un�@��2`��7R��c�
�8���]���B�
�Ż!CN_���Y_��Coz	��*ސ2�"�'��|����n>烵����;1�M������I}���.A7��O���\��,Z��g���#C�f1�a"a����H<��CH�؊胺�9�C
6���HJZ��=��T#�D�i����sW�:X��z�V�AmHuN�ı���aG&@�h�51�����:�']6��lLM��t�T~��F������Uy*�0{�W*�W���k���6���6�����5������������b�o����T�����l���n[��t�-!t�Ԕ��B����B0Ș��g���*��t0�4�Rc,�Ot@�Ht.�lv����'nSW_�)Wg��"EO�C�)4�LE�[����ȕ��Qi�T�,��h��E�߱�ϵw����e�䠄~�E�����u~(d�6��jٯ!h?�̫w�zS[v���
拎��[��D?Z��d�0[t�9x7�x����(J�Js�� �R#�-�n�˞(s��_�~B���I �:jJ��ו�2�b�y:�#�9��-�Z�?|%MN/�!Aqz!��"��jZɋ�T3x��6�o24`�mᓲ�����p�=Up��U��:�����ȷ+7�Ǉg =��
�;?�}}W�{y�~r���>_5^�Ksp�_�k�=F����RJ����\i�T֨}��L�psb8;����Xg�Nh���������EJ2�NWf��v.��T�Ke�2J�Q��ȽFWEw�`|�j���c[W���ot�a�>�e�j���F@�Dhw	yS*W~�D�������a�}u�K���P���zȍ{ef�%������e-�f�!7b���)��C�w���"��e�/{Y"
�8�朋Wy�%��mB�1	Ur��{D
�(��R6�Q�XNĞ=��H�۰�j��j]`B`���%�2�3G����״Fw����y	��'mo(iD2��EuE/+�Q"2(,F�=�~� ���ʌ�=1;�c�A�I��`}y���:�y�nG�ܪ]<o�A\�p[�{��+k����Q �j���c�YZ������1DG[�8�1J�A�geo������ �&�x�2U�Y2Ե���DM�@�evP.k@�*�t�t���ʵ]A�z�u?{x�ܲ�3���{���0J8�Z42:%� m��m����`?&��@��c�u7jD����\��[E�aB��va$l�ؙ�G���;��:��;<P�n��H�%�Q�ɨz�D4�1L�uvg)%R��p�߃B�lp砫h`���
�C�_���יu�N�ej'_������4 ? *��r%� �x����RG��
Vп�T�LO���b�ʤ����gJ�,P�    &鰠�Y�>� ��w���+�����Ǡ'���"L��~U�����p(��vaX��~��]6��O�l$��yп���yv�sb�v������*��"3$�<!�����e�8n�Y����J���^}���+���`@�O�����j��Z���g@��f��]�W��0��
|��΅I��1h����A��l�y������eo����i���(/E��گ���;�N��?�����ǳ5�}����dk
��Ez@��c�}���=�~�M����>�U�-��Y&�U�g�/���H�XF�ht`��7�֤����j��)ejJ1�'�8Y�I��Gj�%����n�}c7�s����m�����6�35�	�(6)U���Y����)��N6���T�J1,�@���X����/��T�����-Ͻ*����{
��:���_�#������.���P/@l7�B��oo~��Ӻ��@��<��ͬȨl��۳~�zͅ�l�s�/D��2��_V�A���?�d��zSV�1^j�j��3~��4�i�X�����@��=v��3 @2fl��_q���-/��;b«U��~�� 2+R!T曛�=,��by��ڬމ��&�l�ص4f�6ݔ8����u-!�XO��[C9טE�tcw��Jڏq�ͨO��{�5!��h�s0X3��8Ǹ���AJ�o�4�Ni���M������HG�����W�Z*O?�_̡\^k҈y�W�19Dk��\�Y^�Q����]��O,;x5���s3���g�?`�uxev���𰠢��m>�2�y�d1C�ǿENp��Vt�a'/Ҭ(�E��I.�y�K(Z��[b� 6ТM0(�H�J4aS�E��oFPD�� �z!��"����Oi���[o'+Ï� ���\��c������+tE�ŜO���k��x���,D��DC�P���0Ͳ��-�Q"������_�ȉ.����p:6���ASR	UR��,/�����?H�c�����Q����	ږ<[��k/ͫ�d[T�?��	_��������b��A �B!�&z�??����)�ޯv��~����ۧ�SG&Y���u�k�&"_���5ۛs;�]Mer���̈w�dǪ��/fyHM��r+�e�Ή���ևUTa>%���r@1\F&�:;,O�ұCSѰ���-m�Ư�ճ�3���;8@��<� D�SFfh��Z����7����J��~���o}��O�L���o�Ao����û_�_�xs�������m+'X�6V�~k{.o�'�qDY�������E�U%�֘\>��oJ$u�>L�dg�0���\G�i7T1v�0�p��:�����PsҼ���3 �l�~,����;�(=So���L����,���6M}��+��pȊ~l�8���Z#`�j�=�s�{�P�w�J�櫻�G}��1�KHQn����ޮ�y�[��m�zrH�k�$ɳ<�d�N�MEQ����%�16LB�'Ƙ�q�v#^;��x�2�;���ßW���6*���9��"kI�(�l L?�ρ��Rw;�2+c�����T\Z ��a�fV�����bz?ȧ�\t-�2�~2)�+��9߃�e��_G}��!گΪ1�ׅ��Z�}ʕq�H%e/+�"(�G�q�y�uAT�:k}��
�$��z�V����Y��MyҼI�mp��+&��PC����b�RcZ��¾�R���Y���;6y�$�)BcZO-_F�Ѹi�;�`�������Ͳ���wV�4�@�����I�$�����anB5�u�X�qj*����m<Y�ͭg"[̺��[�}~�qT��+R �g{ ���HE�]����ʻ�|��Cx�UV��6����iD �>@���r%W�z�o�1���E��r�k�P"<���"�R!�n^��D��UWtÐuN��U�w�b2l��l]��p>�����������ӟ�Տ3��^p��,�U�0p�~X������:y7��;*{�Ddhz��M�͌�K`���:��X�f�{��M"GI�����ޥ�����PԈ���i�8�l�'Ҧ~(�h	��̗|���Ǚ��#&�.��+d?B����R{�ENe���/��OĚȺ}(�MY��[�
�߬�:b��Eك?�Ȋ���%0�-��V/��ʎ��y� �U'�O@��k�:�T�P	�T��{�ZSpp_o���'*mX�|+u���y9�J���v��	:�҃�[�ވD,-�+S�b�Ė?�J!�"�;��&�P)?, u�������p.)n�5�_�^S����R`���H�C���^�y'���i1*�P5���H,#dPj�9�*��])�_[sJ���ܣ�"n�����d�20�&�q'U�u�\>/�iOO V�b�<��eAY��4 ��y��cH����lſ������H�Z"w�����|%��N��CR\��7���4�Y)Xa��b��CHx�Kg�-����TDBc�����Qn������T�t�x54;B�Շ��y�(����9���2g;������Z�&�A�3������S�_�F>�[-aå��|^���[_�4"W;L��Q���ʎ}�ڹ���
��9g������ �<~�J��"���A�H;A�Yq�v��n���Q��X����M~�.��0��a�_�^S���]+����{�\��	E�ujr\��bX�ò�%Bt��~��HI��$�t��`dN
��ø���P[F	u8��tk�ǣ�͆��!�ɟ/ĉ=QB�z��)M�8�� ��Yl����;֯�X���@?���?d ��s�C�52[��G�������z����������;�s�M]
qUnG2�S[��]���E�B�����z�O���*�9���ySS��P�dt0:����Ax]�3!z�e3���ԙ
�}��!�¬Y5T\@�%�7��I8u3��#%��٨��eO$bxU�"��1��o$H��$����=���sx6Ž�#[OMީ�؛�EP�P4Y����+�}[#�_��{h2�d0D��Pn��t9���ɠ�Ϝ�v����7]7ۚX]�(`i+@�c��
!��7��"�����Qy�˶�����,�9��\�"Jۑ���g�YI���$*�1�x�&N�|��o�k�����ͻ�����8T^��c,� KnX1�13�^v����2�,�T5v�&��&.�*�Ա��"d�6ň�屟�dƇl?z|*DB��ho��*J�,/:Bt�Q���nV�DqU��	Q�t�2
����q��gQ����Q�3B�M��2i����^Z/��Y.r���EM>m�&pPV#q��1Q�Ab�bM��l���M�;u����$�M���cmb��l�ef#�����@?�H�TU6�e�ɴ
.K`�?�p�L�=����Ǜ��l��U�9$J YԆ�}W1qZ*����$�f\���Ϗ'M������������2da�9���S���m�Z�B�qt>jj �eu�iL{�ų���2Y��Ա��*%Y�J��kY�LՑō���.��LV�f��+>;���H���9�1�a���*��9�=ٌӈ��7Xv�4�O��{ʓ�,%L�J+8�EI��Q�c�5�Q���%�Є<v�Pa���K��!C?��^�D3ˎz�IZ�a��i.U+���e�.�y!�k��Q�\ַ>�L��dQ��ޕ%��� �R1(��O?�U�{	q�+��q�HW�F+H�u�G�?��^h�v��m(��^v��0�#M�L� ڋ,͗ӥW�`�FOc#��C�֯�>y�ʘ!B��� ����J����ID�/�l��uLek��>���Ӂd���� �z1�z�'btU��v�_��V��
�B�`����3%s *�{8�k۠��	cX�y@b6n������p1��*YoI�$𦧎i2������*�@ٳ]��ջLG_�����<We�K,+�I�G�E�����d�b ����+�F�%_��z�<S�&��P��:ET�@�|o��Tb�`+��jEG�mB���܄��$D`    qQ{|"����L�,k��T�;yao}b}	ѳ�����v��@
�ֲ���N�o���U�:"+�z�kkpb���e��:���ȤJ��~^��H���ys��<��~��:x���y��w�������m���͸6�Dأ۠���X�`4rVW�9ҹ�c�N��������Һ~c������T �U�$���U��a�V�-�ս��'�G����gC!��ی>'y�;٠#�T��E����*����F~�O��<���yE���;&��b��#샳�����<S���[��j���x^���<r��(v�T;{���# �����,���`�d\��m�K5@�0����W��a��C�ch&�b_���FȚw�}'�Z� E��u7Y)ze>J���M 5cđ,�������VMF����5�����aQ���|a`��]s+�Z^�@Vݕi�L��\��ݲ���W� K|(������=�a)�Tu���1����Q.`�}�ܙ,E����>,�=��
�/L��*��3y�O3�,jW�� �=X��  �]VٗM�\|{	b�z�����AuD���l���4�a�����^���? �Qp�|!��.0��g>�@���=����	X��.CX<���{!P�k����Y��*�S����I��[Z�a1�q��3D�z����Ր�^��K�z�vMKϞv����R(����c�:v�]�#qflA���:k�1�W�^�,�~8E�h����]d;��<�
KM[�j}��W�>>X�h�H�@�s��f3Nϐ^Фz�8R���7�y],�C�MGyS1f_�r���/t�#��je��:[&S���������;j�M�P0RCB%��˂0u6[����ol��$�r5>R�@1��K�MD&��� ���s�&���p�{�:��W/O�����l��dx�|]���6Y���.�}5� G;�<h<�[۶���-=4�/yo)��/�#T�LV	�,�ce`*��w�B�T��y���W��b��OK�W�W��g�o����2u�~޵��[�vB����epNJ\R8�� 4D�/�zq���1�����t�٪�����bj���2�dXu���K�D�i�M��j��-m!88STM���1�)���z�ه�����hzP4im�k��q֘_�򷥷F�>r(���%�dE'�S1(EQv3m�:����"����޴@����<y�j�ߧn'��P�����ݫ��'ݴ�l����Fd��1z�6t_%a~�!��igR�T�PF��g@i��l�o����j�Lҹ��hޱ3:�"��g��/��h��X~]�*������+y����f���6fhʀ[�c��oe:̥����tn��jJ0]�����h�/�NR̐��#d���]�T�2sq����z���~�� �U�:��"/��=�d��`$���d\Y�h���e�4�T>��3��c1"�5�����֐�̮ϠZ�Ja,۠�4�t�0��N����V@��wc�?�R�-��2�����g�V��&����-'z�P?AS��4ewT�DdY���q0�i�J��`0��CRr��/��hRƳ�$�g�8����b��x7X�hhKtKz	���2��������i͎��*c��Dn���g$�)}���V�*{�օq
�k_1�A�ֽB
���l�q���Ӹ0,Ϣ�A�s�o��6X�u_��ղ^3g��귣�
c���ޝX
7��k;|汢#D'W|�ޠ�Dd��n�%��7�x�gBW�#��9eoƉ�1>ШX|�f`�c�5���(�#�.�
��&Q`s0�}}?��*	�:���H�ա�L�e�fŮ�f��_	DЩ/�R4�j����,� �WzZ�$�(R!dq_v��0�H�=|��8	*9�� �Y��o�����d���7��̡�gf\�r�u�Os� �	Kp��-���D��ۭ��F�X# �O8l��N���)�Ŝt�rq7C�(6L//ɱ+D��=�t19T�aIV�"�b�5��`�!���(MT\͛�_Wߨ��\O��RaRX��3�}�Ɨ�{g�:{n���L�������>ꈂ'^a�.֬�m��߫ ɽ��zг��x�Z���!����̺�e> ��b��3��叅�;�����Gv1/Q�52y6<-�5;������4L�+/k��6蟼l�z����]�6:A}��`�+/C�j��v-��p��E}�c��s����j&c�3,O|W�1��,
1�������+�r���>�#"�zr>ּ�p��H#�D���GnW���40���\	F�I��ŕ��+m~�n�U���ŧF]ɺ��,%�ny�4h|�&Y4:��ٴ��p1���*]4�7���[9D�]�^b�0H�H>f��sMU4�2J ����W|��Nη!߱��4Ɯ��x�3ogݺ4�z���ۆULU=8�d����E*e�/��I������'ȧ��I�w�k��eW:RD��ǣ����*�M�r*��p�Zz"6�T0)�#��فWx�#����Y��8,Y�$��-$*�@������D��R�|tl���L�{k���=�E��{m}|��E�I_��O�#GtJ���`�\nĲYQfy��!�W�`�XY�����Z��b��E0���7l{��aĠ�Ļ��l#0�N��3E��(�MV��Gcς?�b�vqSz�o	۳$� 7V�n�$�4ޗ�7�h�������ZR7��RsN{ȋ�&r*7�v_�Q\��M{y�XE�tb&.�l�%d�ޫ��|B"o����$��ܫ��QkϘr�0��w�HS�k�C����ȍ�JĖ'�X�յ���X[���݁��F�@MA�����A���Y��lpU��{"6ݩ�v`TXK�l�`������Ԭa7����df��M�L�s�_V��a�t�>e�!��_,N�����0�S!M�e�~����g��OuQ������:�4@�:� +V��on�}xĸr�S����ߎ��(���.��OO���{o��-�NP�>����N���L��H~Ώ��ӽ�b~M�:?��͏�����<��������?}� ��z{ �����A��e��Oy���P��V4�vr��,I�k�����2�w�(�q��t]Y��a�Z�\!@#�SSe�3��Q�]���Np

���vҧ��c���w��~����$���NՍ2Z�w�� �Vp�G�����p��1��x��˚*��t�Yx1`y_MMld=op�1˒p��b}�@�θD�+\ʖ�Z5c��!k�%���Yۑ���D��O>c:���kw뻋�n���~�P�#苺���8�:��L8����m֑��� ��^�1�*���s��:�4��mc��(�$)�%We���w&��gyu+�@~�9��E�:P>�H?��xӥ�3�P@v��d��	��9�"�,��J]^�w�Q���ٵ�!ȴ�(H��!,�g��{���:���$r@�ƴ��A�3��Zx6wS����ax]b+��y��x����^�6)��K֬^]�����8��|lV��fL��l��Uw�?D�Q�L��X��^U8�G�';�}��$��}uA=�I2~`|T_K0���.��^���E�Ɇ��+��n���\�a+��?��I�H:{(��g̜H�,¼����~�+J������]�n	�#�Q�Ɍz5S��-��N5���xz�{� �[
{Hl�S��}����#���&ٔi��Y�`&2���ܘ�X.d	�a��T��4��4_��4���o>�'���̾�uA�|�q��{�����L_�:��:"����{A
��4u��)@�Dd��f�d�u�3:	?d���S��`u��V��@Ĩ@@���4<���JX�*�1}�P�@���{�X��Fb����"����<?>B��~d*х��K��<	�
��e}N��ƸeW���hI3K�f�mc!�� |S��xR]Ͳ���-��Ǝ�Z7���,    ��3�
��x�ڢ�(�aكnEvU�f�Z��� �0�6-́�\���VrYl麿.'�
�����آ`�ٙ��Y:�;WJy*��1�ĎA��Й�l��	��Wߤ��{^��z1[4���f�T~��۪�l�����a�V;U|��V����C�Q�Y�
k|JS����l#�{"m�9�oi{�̦�;�yP ���ȇ��'�Z!:����`�[;+wYgN��l@�� <!���*��<#��+�5�$}o���G�A��xb���'��hة�UV&B��QU�!�#T�@�]�*�h\CC2�@B!��h"��X�&�L-��&�|��`Ś���U��^��♍Q�=@1$���W�^���~�;�����(a��a���~�S��FXST���fvJ��R��0O��d�N.R�������WŰH�~a�g�}1lRC�X���:7�'jH�?�V?{+��|���$N����K�T3� �����A{p������n���դj�"�>�8`�i��L,�v	��f�i	S�ˆ&*Vp#1��G	B�$�K��FFץ��e��y���2>\�|"� �5m;��t��,Cͥ�	�L�u>-<Xm�b@`'�P\��lDLۆG���9R~�T�^��ؑ�<c^�V�M~�'cի���J0*����� ��������5�!��j�QL���T����갮䷙.��b۾Y�*�,��T�J�IK��]�n�=S��u�T|.D���7$�}�s�Ϩ-�g�DVŗ��7�{oN��LJy����V)8c�����@�t�����1Vǎ�9���e�>� gk%bYB/܅� ZbE�~5&xR���ϲ�U��*H%7�i�]~Z**<��k+J����A����eJ<Y?�	��2x�r4��\���4�]F�'M���s�ٲ	vܺB\�:�n����h��:��f�R��"K��^�^�ܶ��?IS��պ�����ؠ����~�P\�.�����[Xs|.V1��U����:�d����[v�eޕ��P���I�ϭ�?��	�V�2���hJ92���	Zy!�7jȌS9�x4��1�֚�uޑݐb`�l�p+�v��(�KN;�5�@��֓n�����-�٤TVy�J�Ǳd�۔�z�����*�h�GX�vD���2$����i�YB��t��d�&��U�f����#D��_�u�'���Uq�T3T�C�R�앍��@�ՙp�E���(f���^��Lν-W��b��,�a��@��N��"Ͳ�W��_�Om�`s��FN��k��9b�$�f���[����d���c6��C����������f+T��5�rW��uu�V�|?��ʩ,����,w�|�Ͳ�H��A�dJ�_�B�J�]��Jev���{�'d>E����td8��!:O�6{~2��>o��*6nd	��T��O˧��2�v}���n9�ѷe��q>�>�b���5��
"4�!5��"⽆�V:i��j�aY�������c,
���Ѣ�ᇛl8�e�ƭ硾L�tT��H/묾6��`z�pk=�<�v�H	�^)�D����0�ᒵm�������JRs���ݲ$�}r} �^�ɟ|^&F�0����B�Wq���8.,�)�q�(^��pD*�n=��g��+���Aj"��]��h�G���J`���N9Q�S7�v�!�k	��=�)-H6�J$D]�`�d��f��@���g�<0�mD�����4U�}�+X��὘���i�?��Z�������xP���'n--�]��	+܊����[�}U�X5}r8���'�����yV�Rt�����(q�Ξ��a_@HVq������!�C��H��#l������uo����݇�S�_���|��O3��&�m3��� ��	�r]{��/�+E�C�7����[���Re0f04��9����+cIW�c5Cİ63�Q���"p^��#H�^xq�nF�dwg���w2���ewPf�D�����F�IkX����̐�� �.�Y4k�&6r�1��k�{�L�ۮa��xK�\;~�	�� ��]��z������}���d�T��C!a��^�(�u���	~Hq澕I�A~VP�E#._�́e�k9�Y&y�����WvE"2q�ͲĹF�T7#p�]-��f��4we���kQ�hy�N��i�T�V�S~��(�t?�cW�;�bp6`���ԄDC 9�Ӈ(̭-�|�\���A��v�P�
�* ^�|pVZ�)����w��kQ�N~��R�ؼ���m�[G��X�����'��1GG�8��Ѵ��3֒|b���X�Tc~5S�ֱ��|�o\e�^n�U��>���nL)� H��V�?^�x�{4�3�L��cwDMWj�խ�ft���I6.��K�L�2����wk�bP�vwxW�2 Y>L��u�j��`��^�w�@g��MϠ�fW���u ����F�K����b�fnt3�8o]����-.��)��E؆k��0���H�ʅP����h��$�P�t_B[��oC/� ����ݯ4��>�R�Њ� L�35��wGƤ���+�_�C����m��{�dW��?�+y� �����I|�M|)�w��]�~R��C��T��U���)�,Wrsʺ@���%k6�q�%�&[+�.=F���yQ���JP�sd��������Paʹ+xT@7�af�e��s��v��
e)Y�bP�ze��C��	�u����G���&z�l�ɻi6���P�Et�M�Se��@9��
���Wng�r�k�P�8�v���m˻�jd��0���[�, ܨ�	j����5ܳ �^ӈk�N	�Ez����k�=��OQ��J-�jX+o� DO>&)�ym�I�w� 1��ٍ
p�˕G�䴚��¥�u���]����؂x|�2��e�K�Ҙ�푷�(Ig������t`|ilPu�!v��>����c��m���=�����d�%c��ym
py�s�f*��������,rO���+��E? d*�ޙ/ �*=։���SumT��)U���swΫ�^�<��-��j����$����23�[*i�)�~��!7��h-�����)�zG�*��ɟ���UH�9��c#p,m�a-�qN޴N㜲u`nA��z�<KŨ��.��V��fRT��*��>뙙!G_h�9ݹ�=�rg)��$-I����w"�a�yD�'}N���(�,.����~�-��(�s�1�x�����_�_��G|�W���{���p��R������*��p�ÊV���י���r�ȜN���Y'���������<y��o�M�CV��1��Y ��	)�g_ގY+O�ߨ5�ʨF.y���Jw�T���C�KUu��O��e|���}���c�͍f��7� �G�+��e�����Y?��[�En������.���Ndݷ%*�b:[���P�fh�h���i�adJ<�ܖ�.&��B�e>2�2�X�"�E3a��T�hAo'+3�l&��b�b�����!c�2'e�攋���KE��0�f[��(�=w?>/*Xx�P�����T�Os�{A4���b��֝0E��=�r˛��v����Oʐf���>�مhp֟��g�&:���?�G��:���%bDs�5MG���8��|qU�Qq����S�i��}�mgB�?W���^6~��h�p�@9��R�r���X�2m�^T���~*�e1JD��m�J5��D��l���!N��'��t����X-a��MRe�C���HޝV�����I�h8l[X�P���N��<�D�!�3��?����!��ؤ���b�KGs�����%i5���j�.��n�$��3����(�/kU�ʻ��������7=̿(��a�a��~He����㦻��b7�\���Q�zz��u��ǁ�p,Nm������7���J��n�e
�x��Z������z���:����?�ܼ����R0V�#��� �
0\ʮ��0qngx
��Ia��j�    ��� �T���'���i4�!��X�-(B���Ỿ��Y�2., 6���ZQ=D�үA�;���qǴ? *r���`��Ͳ�0h��}:���>K8����<ْoG+�Q8�jB�5�Y�[��Q�a�|j,dF�1���mp'!d:�h'[��,QJ.(N�LK?�W��N�-J�[�:Y_�-e�������ā��IEu���݇h�Y��-X���y�T$l��E�q����e�3rP4�b{�*���w��y"��╮�>����.=<�]�� #2�}z��դ^w��V��ai��A����r؁���'��툠��S݌/K�⣴G�aÞ�Ə�K�6'dh(n����$ �Y��vҋ�c��zPK9�^&YYs���!��Q��o�B>�X�q<S�``9{�J�i3���X5}T��&��mw���m�дl��tSы=$��>�3��I6��^Q�z�]uE�u��>��Q�#1@kqDy�kq��ۡ���*�e�
NQ���]��0ay�YӪ����S�J��`l�����c;;v�s��W�8J��ć�C���T��Z$�Q�c�zc�#��:W�Gh�яŘ��(6S�ص$pr�h��"���)�\�Y���[$B���	��~$�r��k�����of���cw�0���±o�x���f���Vr:�a0u�va>w�7��ȶc�0��sb��YC���3�j���NMgD�����UI��?11���Z��)1�0�6h=�#��P�B�Q-���Q�9e]�4���{E~�90��v�"���:�`�����xpڶfu3s�����Kb-�o���{7L,p��ښJ�y3�(��}1+��]ڻ�f��.�1/з�u��#��������ݫ���a׷c��6������;[�$ܑ�d��
�ƇX���H�kV���	�G�[so`%�`���ITu�R�!�5j���p�!U��P��ঠA�nv\�x��p�몭��pת�v�F����+8%���_޹|Lw���Tb��0Cx��)�M�w���ӛ����/T2MH�t��Tѐi��(*��q{��1��"~W#O8���9b����M���cãg&p�S���G���"� Ho��@^K�.�����̧�ǢԌm1Љ0׎7H��(��w�=)��%��$�7�X��Dq~�8�G�vם�JE���I�a������c��$h�Z�&�����fY��e1J�^uE������d��ٚ��MI�S�c9�ƴrغG/��U�L����n�|�P�W"�4BBmMC,A��!c�����! ���e�ͺx�a�6s·&o�r֜9����b���2�y�:#�:�,¡_�	bc��;���B8c�,xK��]q<;��A���	đ�N�wr��y)�e>HD�_us�P(ǎ�!rNm�nCb��3�H���3x��(�Fe�W�FM�$�X�dB+��Q�"�A����u6b�f��[�ĉ�Ӧ���z��~����-`=��j0�-"N
���E�3��T3���|O���pa��Bx�u��s�������V-sx$=�I:���9c��貣����i��R�̈́�K:6rha�;-!��xT���zI��r�[��On��ZS��~�AL��ؤ=��/�@�|:F�T+f��{@����"��V>����	?��D�����g����_W�y�72c���|��ܺ�ы,q.�5'6���Q'u����(�턝��j/A�3��=����QyQ�ث��_�UO4�QT� �^&m�gY���WwϏz�ڲ^YpP�.���UQ
�YG[Z�@�K��Sg�:M���s�~x��1HE^����'b$��������$�,ʕ���g�H,�l>?Q��Տ�ȃ�V`�Tш������l���q7��so+���v�C�d$��xd��áU+�N�N���y*�L4�.̂�ds�P��$���6��ǵ�9 ��u���r�S����J�����ph���#e��r�W�=�x�>�����l/�R:0�Ҫ]�f$ۂ�t�����g��ɍm���S�n�D��B�ş:W=�=��3c�����/)�-q�$*Hj�����}O�!T��4v%�,vt���"Y��+�Z��j&����]�&���T6Jo��m'Y�IX(�?-���M�61i=-4��l�n�C�K��Y�$5���d�7}C�Ph�zɑK�)��_�yb��c�-���a	��*�wD���v��$�C�':odL��Ķ�Kxg�[���o��Ӱ갍��Ԏ�|^���f��2<���͞>�ը@�d9d�G:��(-�:�t�0���烞Tcz5���u��a&�[v	������tuY�'�Qt�T�;���#�����UC8ٓ@���'螀����/F�/:"�`7�TU�\�R�J����=}�{�ɥ B_�n����}M�~-�?h��x�����8u�^Ţ�P�zv@�R_y�ꢡ�+c���Z�(��y֭m�\܄���yt��:YN*�p$i���;��Ɛ�R��q��AI��Hٍz������r\�r|�8������h
�âh��R7B�]�d|��[���/�x�xZ��q_�^>�yUxZ\���T��z�)E�W%z�	Ԇ5g L�رt������ص�88a`��\ft��y5�w�\����y+،}��d`Y���ir�U�i�LFK��:	�tVrv�������V2�J"�n1��@��R�=�69�4��oK��l35Od�A�X������ay�4=�T��,�|aK�<R��^PA����QRo���y�5��j	y_��ɦ�Rw-T��A����X��d�:h/l�IPD3�X40$BŊ��\� eOL+1�8z��A�Y.����Ƒ:	�KR�3V����s&��<ǿ}ǵ�4�r���NigׅJ]XCh��U��ݬ>�Y��;=���`����BͮEXܲf�����a`�(�ݛ�h
6*�7�E�^6�
\(a�i�|A�_ JV?8���Й����%���D}`�T��'=��f�!�i�q�l��
��%����b��A�/�u�TBWh�����*���7|�#����C�ج����T��b��~�*�e`n�>���^>^m>̄\���?=�a\�C�tnK�A�j=�{��?r�Cv��J+Y�0o��Z�!�ţOLZ��;�u�P`�-��pg�z���x^hbNL��N�F�$آuf���1םm=�B _�nMSq�H�b�K\�����^���Y�1?�O�!w[�\�:��CG��!I�!�⢺�h�<Șl�S���� �z^VŴ*����̢�fw��䥴]FKT��lV/J�ÙT�4�b�T"9DY�J��a6"벎��E�q毜��(_��Ϟ�����8�^d��p� Ýc��!�j2�w��E�D��B�y�/�V�Q�O2����G�wd1&�����Ǵ�[��"�<��\W��^$)��~���jp�QF�y�G7 ��>d 0�R��7UF�>?��\��s�<��N4y���v'�����/J鲭cb��Z�%P��G.Z7$�яW�T#0�}�]���R=�WB9u��� XH�o��`��G��U�c���-g<d@�\���q�|�X;�� � zx�V�Ng^�3ݙt��h: ��'�հ� J_���ʂ�#���eJ	vF܅��X�e����j =�М�c'��Rv�:�)<	/���éS?�b0�\뻅���l������5]�ŵ�'�=kuv�2��!��5 J�m� =��ħY{C��U��ez�ˣ/4?�����(�&�Ʃ���q��b�k�=���y�mr��h��,�t�|����a�F��X}�H�e8H��A�w^��E��2l��T�&yT��zCr�^�����Y�pl�p'�+}��jW�����ɦ��<z�����1ǏA���m�~�)����GT��DRt$}3db�d\6���i�HW?^    7X���Q����!���d�Y#Y�l-�G����~	���+�T�i&��b8gH�SR��L	0zcEV2}I��V�_Ɗ����	\�Y����Eٓ�|0�#�2L2��u�i�"G�Q���9w�pǈ�$�jt�H��(�bY�-�2���&Y��l8���j+Ԕ6R̈,����9 �MBftٰ�`w�fȖ���HTj�v���7.�hz��Uv�z�) ��f��I�_��Kz�������{)��0��h�jeىn�z��C������1
�}�V	9E����6�`��!�T�hE��A�(zb��b��y�����B��#�� �͚ТK���|�א9� GxP�H�t]CɄ�EØF������z�ɔ����g�!#s�^�w�\I�3�(�-�/1��/JN��(bt1�����W̡[�.1����g�y}m'�֟6s^`���
�*��?���������Uނ��Ew3�>�e�e!����ͭ�Q�wy1�I�T�ɩ����>WB,�& �YaK�2��%�f�&�o}�!dݿ�{�J��t�Z{A��HОy���#��t)v����B��ө�Ÿn$?��y9.Ș7Do�:��$��T�1р��T��*&zr�P���%�Y$w�hgOP��M[�
���\ɭ����k 7Q$���` ���/;�0�h~Cq7�#���'@%�p�s�8
�۪�t�2I5�=����dl��yQ�ê�ȿ��I��.�,2ϖ�^ �:�,�H,�l{U�2����|n�(��=��:)B��X�˦�|�/�=1��i5 o"O�A�(��_ٻ۞�PO�'*o�@��w�>:�҆��F�Y����YD�g�0/
�s���"r�FR
%5�=�[���9��7W��sc�CE��"����<S(��~>�#P@�E�L�4$�%�)��f���M�_��T��|Ǿ�6t1�֋����Z����,�|D;b��I��m��H��ql�Rmc��nG�	��F��#���*��TD��Т�$�uK��t�<0ܻ��+��0XL��Էu#�i�5�?���������Ϛ�,�M�vN����*zs!�	���_?�ْx��L��8@���X�v�F{�q�^i��0�&�K���y�c��6 
ޱ{������ͫo�{��������ɣ�CRk���6�/����6R�u�q�+�����`E2s��*+jt�<�b,W���L��b8,3�U��#��)qr�q\�� ���4�π�H���zX~�v�"f\FD�d�Px8	��j4`¢[�/��E��J��Q Z(;!+�����Ԛ,a�K#G�%��t�F�|:&M'�0"�>D{>u�JChx2�x�;��N����$�s��p?qY&c1`2>�BR�*+�0sǱ��TzKd�בPG-Ԋ[��9��3} 6�os3Yr��՗���m�V�D���Z���s����REl�)������@%+#�ZCZat	 ��)��!������y��[&L�K���*�rg�0�c�΋xD�"�1Uq��L����(�~���C\ן��m����j86����Ѻ�~�U��T���JK\��O�X8�G�|1D�C�����
�P�� �����[���y�>mW��}������iuB�-g�a�v'3��[M�C����Bq�#��sR�p����A��u�#�q ��.�(�����%:^b[�"J�`�W�O�9|O�����ێ8�Uա��/�ƌr-잗�"w������~{X??�6�6�g�SZod���w��$�I��)h\���<0+�x�]?�^���"c�'�Y��v �n���;�?��o�Y�z)�u�I��^��$����%,��Q��
�q��b[�ɰU��_�Kn�9Ⱥ�\dhe�/l��7��f0N%���x�J��<U�̄�y��!e��y�/��X�D�'$�F<��!p�4R�O��{��Ĥ*������ٛ��Z~�=�&{yJ�{�O5�n�:��y��4^
�XL}���^��~w��z�a��S�����W�Q�\<P��'�g�%Hu��}�5:��r
�cD�!͸ω�J{��ceO�O�[�Q<u�E{��M��i|tHժ�c�D���[�f�0�VF�Z�
7���9���K`�{\� ��]���&��:JS8�x_��,:�%S����8����D�ȴ���r���n�ͣJ��N0^�9�,@��a�����91F��yG�q��6ЖѮ�˦'�Y� ^�㏿ɛM���%�M��X#�3�]=��<�M	5��ː�q�ƤY�jO�>Zx�w�Q?�V��X�ƹ�����u��;)m���dq���I�Ddl$���ve�#c��:�y]&YF�`4O��˾(zEQ��J��G�2Ϝ�H�[㿢\%�@D��#`�X&]�R
�ӞC�e��"�>���r��Qr��%" �2#s)�
t4*�u�Ԡ����� ��$4_2��l��#���"���'bJ�%A�_�����Q}{�j�f�m�
/01l�����w��E�CۧD�uS�Ӿ*�`{p|��jB��f;�ꋏ�7�&7�}0$?r"�B�-�~>��e//�����'�Rd��ߝ=�=�HH�wpWk�ֳ 	k\�-DG�r���M��)����V�����*�'St=R�آ�z�"U��m�)!DNE(t�Ǚ'��N��~��"�H$���m�NZ$�pH UЎ���=�����[]%�,��r���X!������ c� M�m�!���y��bd�5�������aeAJW�����b�2�u=�D1� ��eu��otsh!�>%�hN�/*��W�+�VDJl�����Ɇ�f2��{U����Vߖǰ���O��f^'6:c���i��������f�qz�����?�|�(}�h�G���� �~�3��:�i.ohG�1#����*���+_��\��hL�s��uJ!��}Q�Ű'�Ve�	��"��g�F�q�F(�X���P�8�\�"���]�g
��Γ#8|H(�{�Q?���QTbX��L�<�I���"�Ģ�b��
^L��@�7=r*Uz�P��ߐ�\% ��^��^V������/q*r����ӈDw�iT� ���d�Di��̾lGpAn�Fl;�����3�ZK�Z�NLe,HA�rH
溝i6.x�N^<"Hk�d�WX�UI��ACMv�N���]���1T��`��fY4���LxVV2)��fA�'����x�,gO�'k����_�7���5�b����`��}ǜ�NܾK�p��**�4�"�!���@hX$�Ա"���?S�4P����s�L�+���6��N���a�O2!�ŰfD^EǦ���t�á�8� �N�" �]�a�{���U��Q��b�y3��@�K*Ʉʄ#U�،�h!NNM��c��F���Y�H�K��n��N��6��Z!��Z��Hȱ����]V� ٵG�;�<	�	��\��6z2�Z�j9���E�H��I�߇�e������� 0]xh�6ڲ\�Ba7�E� +��x.-�/�+f��!��$Ђ�X�ܴ�bMlW��?��J ���<���;������X�h�Y���f*�,'�D5�"�]#E� P����9����>�X��h�N����O�u[�� �
`)�2�L��:���:'�21��[��X[��d��&$td?v�	����b�M���A�(!,�yU�H�qF�@�	˯,h۟���J�=�@$`۠�N������/��~:Ib.}�X���x�K��2�ԑx�z��d3�����|z:?қ_�m-��Wu(����8|���/�`4�v�+�܁T���@S����F�Bfz-��}/~�Q���M���͡�)���beT�>|�RQ��d=y���E���s�tPV�"@=�+��U�3|�b}�|��ĝ:��9�ρe��4ꒆ1"F��ѡ��!�ˋJ�\+�r���F���1��Pa�'���;��|�y��� U    �os#H[)X��jyhq��4(�a�֙Q=w���?.�^Hlp΁�";ɜyu�9�T��y~<�
4����ŹJJ�S�  z�t{:�I.�ivͱ[�-�F.��R�_��Z��.6�����,0��wy��|�H�k�ƨ:9�b�;[�5��^�(�r���n�.� ���"vK�Y��[���۸inZ����C�nۜp� {/���s"��AD�tq�W�� �q��I��.���Y׌V�u͒_VW����pa���o�ETBOV��tJ\��o�=�Q����Eov��H�=�v}���B��I<H��\�v�J��,�Ũ�O����b|1,��.q�C������8��ĉĽ��do�%g������`d�H�Q}���vNb��i��TYg�ڛ�d���u��&Y^6��Ґ��Py-߫A�@�Z7�O��<M��>�@f�*w�CIo͝:j24tO��`{�ҁ�#��x�Q�[�LG�z��V��6ߥ�g��up�߯�;��<��$�����\V��z�o4bFKͣ�E���O��>�R�(	ui3�U�AV3�����?6tL=脼�@����&�{4�����_���&4���A�i6��8�����>)�|(_@�W�վ��e�L=D?�m��U�0Ω��;�H2�T�#�T���Z1�	�\��wЂY�&a��$��0E2ج۟����!+�9�����U>�
�c>��r5�a=�J����O�8[qt�p�j�����*��Y�qn���L�8l# �Vd��8��N�9D�U{5�2Z,�j""��ϋE���و�0U�V~�Ҿ�|�7��1�\�y�{5N:���ؼJu��y���S}ZN�a���T��F����g09̒'��c�1Nk�uno,�j�dC���-7F�X{��Ӂe �s�ߚ߽lWۄpN4�%a��x�ɝ�ۧVL��J�����u�Y�\�K�� �jO:��i����H9.p^��eb�| +�
���:ݥ:���4�1�(o�.y�cl]�]�,��C4�*?m����Ԇ�0�8/�y�.�+�=R�(�a��Qը��і�c�E1z�a?�,�{��m;��YL6N�E?/{���*��i}$2��~��P_�av�$ɭ�
Eh��բ�O���A�z\�E&rq1��=�M���]f�6<�\�5�=ҁ�롄�dڞBaX�-;[��v44��!sz������=��lޭ{�g���Y���i�CJ�Rn�b��	�-�+�
ب6,��ìR>=�h,86���v�J�piZ�(�(*֜����	նxt�u�U��m��h~c��d~�1'D����ri�����PMõ�W1�@��%ƙsz�Q{O�� C�a?/���'F�p\�#%9�LGAY����
��3��?$�� c�2�8,��Ʀ����GX_!7�'���Z��n�M��]�Z�!j��8��BN&�m��8ܥ j��)*���/�*��n��!�,=G:�I�n{b�d(�1��9�8����S�8[�
�N a=�Q��Xn�}��V���P�œ���%�P�!kR�|� c��03�����]��I]aon��0{���D����K�[��fI.K�~"%���'��/��D����3Z ]n�1^64(Eou��E�p?̻�h�N�#.�
`̢FT����
�m�&ܹj��Y�b�S�1�_�Jc?�	Q���,3!���8�ѽ�+�	��)XA�XY8��A%Q�$8"��[�{g�c�|x�祼��g��m�������b5�	�!����<�um�].ʼB��TҦ?���b���BA�d���GV�������fO�u���"o�^Y?N��Μ�;�6�V@�~�";9$�'m[)��!RTc�H�>�!�A��7�O����/G��thjއ|S�^�3RK#���v�/R�L��D>�e�?�^�V��s�䚎}(����8�+�n	c��/�� /a+��7kU@:P�Yy��֪�;y���ӹ}ڮ��{B��T6J� ����%�i�6���^�G�9s��_�4�~�n��W֏���>���ѯ����?ɣ�������;�l����j��[���h���S8P�8�n�V�,�B��5�Qi٠�$��R}�����m�Q,D�������]8d9�x�0:��b�|<��Y�7�H�-G�9F%�P����<"Y�N�
'=~(�D��vfl�E|*�t]�N��H�$���\�"����@��"���(�����l|1�N2T�A�2{�[�3�&)22<���+��<<����U��2/��BY�3
��|	Dm���<O�]Dp�p�@>�Y���k�-頥~^>z�_�!Bp���Z�m�n��8~Z�8u}�n-��E�Ж*���b�r��먇[�����t�����a�|ؙG��m��F�Uo���>���C�Pd��b�qlm Qg�ʇg����n!���EB�-�C'�I Q���a��5��|��/��T�6/���|���pd� �$��ճ8y͎�s�s��7N&82�śÑF]�GU��;��!�z����ʯ��,or���Azy^�A%D&��b2�f��6cA�;׉�p��s"�e���O��ɾ2t>["�X�!Y ��t�>B�Qt��3�lA��=f_�ʥ�MӔE@��ť*�$�.�hX�vW�5����sn���\���o	X��,��#�i�����Q�T"
�;!�-V$jf���"���R	����@Gw-sq�z��=�V� ?�v�ּ%y�߶��|������>�����_�o�k�Q������T�������%�� n�Y��Qr�Hįykk�f��d^���;�Q\x8d�����ԭ����j�2�5�@�^}�*x�4x����UP��ǧ�_5�[Ǹ�ޟ���OZѵ�ެ�M���O|�6̸�1P�˼�_�E���%����U#E}����"��o��5�� �6�1S�Qc��j����(د��z���(j�'@W�t��p��,���8����;�̛c5
ԑPG��O�|Z��L�Ӌ�ȼ7�g���J<E�%4b�-mc�Ä������^�$�$�3���h�ap�C,c�x,��9l�/�ށ��L�M���ԿF���n���/�^1���,τ�t{�o�mgP`���B�AIK�!����s�2,�z%�~={��}p*�1��o��gv�
��
/�B�R���ֱ����ړ��&_�Fw	�;Ļ9��x�Q�}��a%�a&�̨�6��0Xj v�rf�)� X����� <����A��!L�P}����AJ�]کf���Ӽ�D�t.�d��C3�����S[�Oz<�#o��WM�z��C�'K�	�u�m�7�x��ѳ��~=��܉PЧ�@U%��UEY��@*3��MU��a~'��-��xB(�ԧ�ߧ��~�.�Tf���U������������~�Gڏ?�tP�y�ʱ̪���ȕl*^�.�����x�S}uhI�G܏��z���#D��n����T	����0S�D�<�ʪ#�Ȏ��L�z��^ŀ�K�M�~X�� RӦ(��}5�Y��6�j4h��4-�(,��6!�DG�u�Ք����vu_R�׃�`��X���ؐ}2�=Bx,&�M��j�7tG���6����{��R�c�c�{�>,���'�"{���3v��B��xSy�s����*K]�e� �k]�΁��|� <��F�?��c������P5�W�8��	^9�m��C��RP6�[Z%�M��ќ
�^ZT�q�yL�� �ά�=V"�����C,�t6"�b ��A�<PRGA����{M�w&���&��|�[��$�L�&�S�,�Ԅc�����9�X��Q1?8��fܥ!�z�e�lZ�~�i�b�2D��%f���xu*h�
eZ�����,����z�Q�P�����	�S6ŧU���;P�����b�u�O-�#��&g�F�D���Z#����W>|�B�9�`�3��b)NNNJ�N�    ᫊��>�3;�	�!OQq��r��o������sM��^
�HϺ�Qo�����2�j	7�yJ��B�jC�����������¸#;�$au�¹O�����b��4����fO~}z��V�> M��$��'��Ǖ����;lX�9pS��/�"��X�%�j�z�/�*�╯�nB��1��]�1ms$�H���9>W3Ge�/�=1��eU�0a���h{1 �( 2���⼅�"���<��'�gp�Bq��Y��c߶Z64o%2�a�yͤY�.A͸�tS^�܋�	
��쏷��G�%)���HTz���dƾ�K(ny�2�ߋ#L�OcH�1�h�H���t���3��ɡ�a�.�Pt��{�[�Ѭ���s��-:j�"��Hԉ���">8���%��m����w��&+�&�\u�c�*�ٳ� 6uD�m��eɼ���>>�dk�t���N�RW1�Ra�v~�Z�EB
"~'����U���*�9L��2�S����R���`��zFߵ:����u�z��٪+j6�z?���T�˹�);���0���W��ޟ����~����_��[���M��4H����u� _�j��Ge�Gߚ�ܐ3h�����i��B�:��J��p��V�����xفw,��z%L�y-3��G��ˮ��ެ<�X�P��T����4� �qN}1�yU���N�,k�g8��4t�=�-Ͻb�Y����NU��*,���t��C8��V�FZ��,u��7Y�j#�����=ܖ�#}0�'ȂD�tF��66��֦�p
�V4�	�m��|�O�̻Y��'Ȥ�`X��~�� �7ü��&Ӫ��Hoj��*�V�9�8�ŏ�t�Wy�[򄧢��bd��[N$��N���drFN7�l�mZ�����7Y�Y���@��##/zs�����V</!o��I1^�ʻSޗk�[�o_�Н�jN������'�L��b8���;s��N����f�HxX����ַ�Yh�ݬ��K3Dx?jd�U�x��n����������Ǡ�����K�W��܀�jj���W���tD)F�u�����y@�&U���,�I�������%[� ��AOj��<�qGw��b��M0ɺ�=_gݬ�c�>B�"���T�.�22���m��r�z-����bB|#�|	ɦ�u}��zq�*P��<ﾗ̯[�4g�[�|`<��_��AA8�yXkA+�n��^��=���}nVX<F^�W&ƽ|T�S�;����,�oq�7yGF��p�'KNE˖� g+o�h$� ��-�62�gj�s\s$v�.�A�b�[,��,�`��m�5&������:����������w�'������=$(�< ���1�y�
tg���f/��o�M+���e�֑.�v�y/�Г'Hygӱ���DZ1hRڹí@|6���ޣhL�OJS ��׹�Mն�6��J�{�K�HG5!�U�k)v#�&$��~��,:�Qo=��M��6�Q%��p��Z��l����_x���"�[o��b�|ʌ��	b��4,��<��&é��7���$�0�^i_����B��4{z���$���B����k��n_ǟ2��&�8f�tx�c���7!�Q�U��Q�2�y����&��K	XG:�@�o�'�ba��W� �3���a�����o�	|���Kxg�S��6.C�V�,���խ�'����5 ��)�0C�rEuҲ��ם�}?��������N��8���m=��p�����hm�ı��0�c���������kp13����й��l����Ue�)��ޘ���Ѧ�y=�U{T�s[��Ԥ�!N��e�`<}U:N9��wc�v1�m��M�);����w�sG4��ݳ��pn9G��$�z��yg��"�<���g��j#�M�A�{	����L��������{����5�E�La+�M�f�������[U;~нF���{'�ק��q�Ùo���f��aj�����A���C�݀j��� n�Rb�[���6H[����avE����r�nݰ��8H^˞_~�ӳ�cBM�I��$�5��y��^�y���ſ�kC�zM�����П(S<�8���*Y����8r���`Ig_�J�	��Q�(H?;Nב���H��QY��җ]n�V[KV��ť�$�2�磾�{b֏�Ȅb��E��	�S3Q*�f� ��t�u\���e�[��U���o��9B#Ⱥ7nQ��s|�k.�R������_1�A7u<?m�	oe��������'��p��S�;ɿ���˫�a#�Ʀp'Y��0�46;��Ml�1Iv\���scm�m$�͐���5P�&�L�pɶh2 Pv�tkR]���3dG��#�"��ⸯ�6�[B�d�|���z��������O�#\����"��E5U�8���x���Ǿ���vW~�[���,�����/�>s�$���̏^��Q�z[g�M=xZID���������ŮF�V8�M#��,��6�©�یn�+<IɃE�	�v��ɞ��I_L{� Nv͵��4�_�<�[B�Y����mN��__��C�����ܦh�
�M0k}���Ac2C�R�>kLI��Nl��L]-�"��qjm.��vېI8*&�V�	�2�=���!q���W�O��,�r_�<����J�X�l4���,d{XEvr��ǁ�?A��V�5�I��N�a����BԽ^u�w��D�P��X�z��ߘT�u*A]~ˇ�J-�#��
��%4l�
J�u�ቬuz3ќ�Eqr���t��mb♜(���)!m3bv����$V_�FqM;�%FG��R��	%�U��j{_#��u"x���v}�RqA���~��oZ�uj^葮)$�ԝ	��dN���ds���bvsΩ<�Ξ���R���jy��5(���?,��ج��r+c�R���h���1�����]#2&y�����OI��!��pz>ӹ:qZ �F�7�a*����P����1g��SzF�I�L�ty8��&af$�_LzbX��j0�Dl�ߌ�d4���jg3���D9��eϙ}���0��#I��k3ˠM�Ç�A.�N6c��Ad��66��4]��
��#X]���Uۺ2kbY} ����{p����}�U^��f�7�\�륬��3�e�̠�5&E_����˟���;�9�A��f|XW�6�-��N�;��
�A�<��%��L������J嗭zgy	��le��}�Cw�L�r5cǾ�֐QTtfrD��� +3�;}��y﬊X���Q�Q��M� �����OL�lr���WE3Ҹ���W>�y�/�=�W���'�Ë�x���%�f�Hꫯ�}�o8���9��FꜦ�m�aD}�$�C�:�x�O<��ڒ9�hj�kE��Hu��ø/ƽ|T�*d�6}��՛����~e�p愜�G*ε�b�"�E�t�����x��S�OF�y��Y&_T~&��V�DCM<gr,��y�K�9��+:Vh���:Z�� �#�W��;����'�xR_���\~H������M��^S44�GK�5�~|�P�&��͟�)Yp�Z z0C�"hF�|��^.�"�ډr8�f!���v��C�z$F��w��p�$�$�ϯź��]���aX�k�H���3��S��t>E�j��8%\�,H �J|����ؙ��=�0\�T禼pZ�.����Z�-���<~����R]��p�gt�+#�I!�(��� B�����⏩�I��ǧ���.�|Ԍ-�J��AMmf�M���>\}+~�5(����{���J�nz*i:p�ً�
Qc�����j�>�^����mi���u���?�_#���:S���UTt	sG��m��9�(d��s;�ty�����u�T���'���֜�&��ě��%CJ�F��k���d,�ވ�@R@�'}Q���������É��'�;˫]�� (ĹwI޻������ڼ��e)w��t��o�9�s�[:W�*�4Y�s�Ɩ $,N�oA;��[{�[ߖ]r`-?gJ�.�r=<L�    �F_��u�.�V��	�mK?\�� �$u�	�'��3����|�$�'W�2h�\C�ximx]!��[Ԇs�rh�<�����������{�> M�0� +�mR�aB�����(Z�}wUv�w�v}��3�9_��(L�>��-��ጦ���s�І��^��7)	4D�M����@Nu	�q���>�x������љe?3��́[�|��|huզ��+���/5
-�<:�Y���x���W���j�%�& OfЇߢ'D5�V�0bz1��T�7<��_5 �u�A�����&䡫G�؁��*��*�\�B�4�(�d!/�;�BJ���Sx�΁�!o>�X�Ɠ��8 %k#�qV��@��ؠF������G.�ߴ�U��Rb��r��~�������:Y�&)nzB��ha�ȱ���r#`,�I�pM��;	|�P��3Z�n�Y����έ�t��[$) Q-��S�orm�ê�[��r�娒��<!���E��s�b)�I|�"�P��q�K���������*M٪&�\�r{n��.߾��;ַȧ�ƦY@�m���k�}@ʝ�,r}�dB�/��$�.v��d�f�Zk�k4�k��q'y�\k�HqZ�"/��7�
Q�Q&`�d��<g���]d��\�	��;�����W��ؙ���?�[5K�1qW�2E�x�,�v5i~[[,6��5!�����6�e�o����f����a���>4����d�r9|���_?������8h���j>�V{ sU(�ꨗ��rR���6���0{�f��u�sxs����ΥqJ�X�瘽�ǣO}[��<��Ɯ���;�x)����j����8�w6
�p��ŰD�!��R��f	&5}�OՊm;�Z�������X*�ݿ�
�~����nZ�*�W<����J�@�VPH�Ks�a�&����F��aR3��"���"��ӪVé�[f��u�Ղ���4w�A��H���o���Us4h���5K�yEr�l��M�R��=tb��RE�dTa�%!�� #j�� �>"��q z� �rl��̇S�[��+�8����	�f��������������~�޾
T
��������Q�J��X��K ]
��^�(!�6*����F�t�ӡ�Ӥ1gcbl��ZSԡ��yjB�ȁ�W�
˹ߔr_n<s����N[]7kE~��U����������[��r;�>mW���;}��<�rI{�A�|��Ny�8�)������1��uu
EU=9E���Ь�Ɓ&�P�R8?��}�ڟ�|�|X�*/�o�j�v��x-7�n}6'7,E����p�j�	D2�	�7�������|��S��c�%��њE�α���3�i;�r�����R�i;��4�����	�A5pܐ0�A��;��[<Ε8Z�����
��Ů���[�o����-�
���>���Y�c��^��Hyo"p�d�b����΋�P� w̖
�#��q��Ev�c����L�䓌�\x+�n�}fǀ���S�ڂ`j-��,��פ���v;1��έ7;~[�L R>?;�}%���W��bS6�?���#<ɯ�<�	g�ʛ��rE� �ˬ�zi��NU�(�n��S�ݘ�_i�Ő'Ax��)��z6GŨ'3�A^2�Bf�ӌ�H�z_-�[��Đ
R�U�b�O�K��H|b�b��kY9
���N!zEQ�*%��b8�3*��[i_�S;���/�A]�{�i��+1�D�����\��0��^"[�z�7�ԧstr�x���w���LU
�@��;��w����F53)�Ӊ+� ��9_�aq_�U�ͻ���Ƥ�ww��bd���J��&��2]�ꦏ*�kt�
�׬����	+WG���_��ꃭf�E�A"/]�( o>n��0$��x�ؿ$g[`1�8��H^哪(2!&�i�`Eo)G�^z���	uz��n�[�Ó��*��fy�X���ջr��<�.���Pg������n��1b�]u}��t༣���O8r/�z�7�+�qӇ2�H^��z����C=Yh4B�> �+�G�ȻY�8vF��rS^���Hw�{�Ke�O��T�%;���P��O"F�1��$�H'���C_�?D�>r�u�-Z�#���xj�gY����|�?m揷*n�"����ί������w����{۷1|l(�n�@9�l�((n��(#i*�]^t�血b��/7~jI>jlʒ|��s��E7�j����a���&�M�sv���~�z5��L�� �K]����B�Sb�^�ɷ)��bp6��/��_���N3����� b��17~Ƹ!��`�d�p�Z�����-}{l����D�<ϕȪ艢��j0�D^^����#��3g��,��P}۟#A7�u��'�	�Z��3�h��K?�ʣ�K�xS��L��Z��dd8V`�ix
D|��]������i5�Ve)[ �3�[. ����;*��a9�Βa�ؔ6�t��'.��zL�%�0Q���m�P�	�I9~�N2q*Xu�uY��u&�11��*GU^dJ�Xf��q�a��F��mV��`;Ӊb'�v54b����A�By�9W
�2��Y(�epeDt�c:�lAb�Ł��wUD�jk����ID=s�,��ܴ�q�6��<��A8"�||8�r������C4{-�c�G5��� �JhA����A�J`q�V�Ŭ��=�t��ԥm��.Y�C��w:ϖ1f�E�f� )�AE��*X����d����&�E��*]ڃ����,���1�ߍ��_רz�nw�}-�GbU�Jh�1�.�us<
,hC1Ɏ��h����{�� �ep� ��/hr�#�W�l�:;,8F{�E�����K��ŋY�Ñn(�B	)����n�s[6q��	����^r���26�ޙz���Ӿ���A�2bp1��ɦ��l7����|�KU��~]�=]a5����������Eb���Akq��Ю�����F��('���HF��"�v���^E:��cMՂX�-�}�f)�
%��f���T+}��d��*�i6�{{3I"J�	6,����w��~�?6 �*�ԍ>ڱ��S���b�����3H���@ ��z�^�u�W� �.�'�'�?)��F��뿄wV���|��j��x�@󝝽1���W;�5��=O�"�Ia�j>���"�U�,b�__>�QUN�BdBL/��	E?��/�) �{�SW:����F��5��Ƣ��9ж��1g��c��G�Xf<]�[ҭ=�QV�+�Ch��������T�6H3�Q���f��KA�#^0�8p��7��e=�(��z&LB�6�[��rQF�ȤMȤm�y�\��+C�P^;�l��uK��Ebv❣,���bi6��뵗���C�6��� �v�ԭ3�5U���f�՟�<�n3jQ��YDLa�U�����i��2�������A�S��2Tͣ��Tá���2�3�-��r�b�S�3C9)�T�L�7+A��s/�q?� >V�ՠ�D;]����r�b�u1R��k)R&qՈ17��'�e\2͂OO}r'@Ɋ��i.�}<�d�5��f�+N���J#ƺأ��؎_h2�f�'Xr��_��:�W!���S�����Drm�y�Bb����PF��C_��l����E��3b��_���Q�n	���>To�w�Lp`L�@�!��rY<U�I5j~t�a�� B�&4�1��іriC�N�r��е:|��2�'���OȕJU��Ӭu��A4�}yA%RgBF�Y%R��@V�{�p����9�Ӯ�i �;Ӿ���n�J4a�ԉ���lsT5�5|��"~�{�k�8��:3X7�і�,ff~W��!��ʅ�3�Hp��Q��9v�#:��	C�ӻ�/x�X٭A��%�sF�{�RΝՀ�F|�<��:IV�n.�rĹ2�}c�z�|~�3�r���aR�Qu~��e�����I�,��2��������uF��I|/��y�:���+d���c}M���u�7ߤN]�gà�hG    RFp;�A�0-S>���j8��"��(�AFԛʜLX|��N�1�8���ֳFM�F�*6 ���Q�c��PK&VƅZ6�O�b=l�ËM���/�����	���)t+��~���x��@`"��R���^������F|�l�GCa�ޱ[/&.�q,O>/I�ֲ����7L��V�$اՄ�⢳7�D���ۖ~��9RjJ4�-Z�*��"rǸ��� Ŏ����tt�d����m`/�)�L�dP����*]��f�J�F
� ��Z�)o2 ��[t�?����A�=1�
Q��L��E�3�����3��y�g;-��[��X��zz�zߛ��~�����:�}y5c��]�ϕ���h���:��W���#�-� ��������]��m�BWK}=
�9����>���A�y,��|�YJ>I\(5)��JW�eZIW�`��
���ﲗ�+1P��\�z���C��M��P=�:���B�� 0g$
����>��<�r0�5n�#����m�oI�7;�̲��4ӪV�@M�MJ2���%������m"��+6{{d�6j���b��)d~��gTm��'Nҩ3Ϲ�g�e����jc��=�2@��b9����ROyS�˻��,T��~B�Em��&�$������y�z*0^� T�򢷊���U���# 7Ī�"�yXCD�^qU �멃I�� �B�Q-H��.�%���	�af�B�x�����m�ڦ�5�u�f;��XY���_E�����C�c�A�N-���Rꢁ�"��uQ"o�i	��q�R� �Sz���o	#GJy�O2{���go�H��懶ԁ��m�����\�X>�|��KTiQC�}�~Y��93Tc#�I ) |��E
�j��e��+��=��F`y�rF��=��O8����O��H䃦�C� Ӳt1��u樋b݋�W���#ܵ3F�n�$k����k3r�Ў�P4�!|w�_+d�FȒ?) �a����Z�ٟTK������坪_�G���Mou���Z$�1��ɢ[��i@$Ez�q��G�\��*�36�(E�9���BX� P�`�n���g5*AOr���y@^��.�[9}ڧf��-���jg8#��UV[i3?�����n�w�a�g�΂�!K��K��ky_Y�O��KZ+��|s��h��	���������S�\�Y�L��Q��Id�`���[��s |D��J��q���;��S8n^}ur��0�:�\�m�3'�����_��1a	^j'߇K�����rTUf��ӌ�H�0#;챌�`�ԜXQL�u�'&EnZ�� #a���a*�C$$���Q�ȫrP�a&���"�X�o�.K�}�"i�OT�[�3%�vhRl�hl�S�u���#�7�6�$
}�=~���'W�[����rM}��������פ�Fԝ�&�U�.tpf|`�K�{֍��:f��]�OWK����q̄��D�/A<�P#����&�r_lx�i� :2�e<�{���c�%��x�r�Rt��h+vm�Kʍ�J����6�/����[�T ���Q��\�9*��}ǫ�����E�kJ@����o<P:֝x5],Z��+�������Z�mw�}_v�\T�/���4YR?��qfC{�z��h+��Φ� �o/d�e��.�8-����CG�&��ق7KƠ.��?��U�a�Ng��,��kv�I>H��ʪ�8�w��J��hA��Y�ʹ#t8�i"��|X��j8̈́�^�������q����>��n�
�+QV�z*�Dp�~�e�L�[��\=/C�N`CR|����w�[K^o�fM������f���xe�1ii��o�N���	%STUY��5�"�}�T�M��L��<�v�{�4�K�`�A�:�	z�T��T}֯FuVx�1�u}wǣ΀���m
=�-�B#��Oe��z�ƉY�SI]�t��u��I"���� ���gχ�����w�l !�AȖ��=�@�ջ^}%�_�:a�������bRF���d��e��'�e?���޹��@��YB�<閐���������hbˡ߳�#u����M���q�ؗ9���A.���%?��=�I]�0�`�F��gCu!␇���[Q��윈ZW'G/J+=r)Ԓ��TU�0�6�� G�Z�:�;t�qr�c̐����U��8���CAf�� �JN�N2@}2�yL��Q�����#�|F�2Y9<p<ϱ�<�D�gO��OʢۍV���)q�����h}����ʂ�� �z:�:e:Ո�Q�D�@���0��(u� �����z����Q�o: U�*�3- �����?h�� ����ą�\������F~���	�*bxk��2	�*bN�������Щ�:�~.`.�V�*DV��R3��Fm��}�@� �"O���~�W�TQ x=WIA�򴅥�X_?��VU�;U#k���,N�H�p�T~H��{�$b!xh��/��R� �r-�K�'������ ���A�>��\g�W�r�H���A����YD�iP�9�C��(�a0��U|帜��Xg(W�0~�l(^:5��r±!s����	*_��C�K���M�낃���R�7��p�|X��gB�/JQf4X]�+@��NVz*�`KB~��(��P��]'c�u�w$�:y��� 5�#�>=�M]�uw�14Vw���͍c�J��_���E[s�(�j���Z��9��ʽ�T��)ɇ,�y�j��읳��9G���`YG"G̙��y<�2�Ի������D<�aE�|��B��^��␜�Q���8�밚(�7�ϊ�� ���ڦ�����]��H��/_ X˯�����|�� ������љ@�ti��Bm�,�}\iJi���G=�%���-KGJ�x�2q�ȞH��n���z��n�J�K[���p�P��o��z�<�H�w����$�*p�1��/�5#����%�TҍM|:��곈H葥Cd��
rj�T \+�v-�BIf�B8�߄�wK����c
�g;+���b�E5U�"��(�(�J�3�:8Fĭ���������^m�c6h�?.�Vtֆ�a�B6c��D���$.���a����X:�vg2T���o⎬Dc�~�Ch�S�$n����	�;��:ib�&B�1=�	ʜ�wiA���V,����f��_O+�#zO�L$9��� `�1;�8���,ZQ�@�Gs�q1!r��
n�í�U���z{=��$AI ��j�G8�uDW���N�)�֡?�`>8�����0A#o���.J��x�i�ױ��]E=�Lbv��:�]���[@,�0H�Ē�
c�~^�߽|\�*6��㌢_������$I�� R�{���I)MH(-~�����xF@��u^�xU1Ed{�����C+��,Z��1jT��]gГ
J�0�]?����KS� �����6���;��@�a�O�`��� W�PѠ�؋�r���(l���Yd����6J7���?�i��d�^�{"̝~ /�B��ʅ@h���:/m^��e�\b�����iT����*ɧ�|�/�=1��A5e"\�b���3��++��
T�u{�E�qKw]���]��s��� �U�-{2�e5��d�f��4�կ��2�<�*_�]���cˎ�O� pB�HR�		M�_N�v��kf�Ҏ���j.�~m���4�yXIi̩B�t��7�F jy��iD�z<#-��؜�~�}~���y	-OP��o��U;[������Ln_�Н��~$�i�փuM�O�qE�B_1��}���=1��êdB.�"W� ��c����p&A���CLVqU-�I��n���TUѹ��%a���,H����Ah7K�!�\�:Ϊ�/�/�[�vB;�hRg%q X�~&+	��՞9�,��=����V0�Q9C?�E�i�2��	��O��a������&��M���y��2��_�~����v-0\W��gͿ�u����I����@Gў-Ϣ����D�$�4��x��;    H��7|����|�q�
xz��)�Wfq�[�(8��E?����i��Y!.�BdD�����1�+�Z��������c��r��x�>�n�w��xp��X�����Y��<�\D�Mۄ�>�H��e-��սi��
J>�R��$�X�h7\ĀA�58 ̋q/ϫ���ES>�"�dIa�l舨|�7.�O>����_+ӆ��"�f	�cߖ� �m�o
�=��C����P�H�>_�:�n�i1K}=�(.vL ���7�fs������(�3 N���
6���MX:�idJS�� ץ_��W�ԟ䂭��&���l�7$꿄wV���|��[����@�(�����zbPyU�L�CY7p&m3��B��?λ���K�~�E.�&�2�ҳ� ��Xq\wh"���9�-�D����0��c����Y��}�ҶK���$)�┄t���^��l�϶4**��BH��t�7��n^��@�q�����  4���7 7�r\e&D~QÌ���h��ð�N8C��	c�e�w?�Ns�������`B����7�"��I�����A'�*X �V�D��n�jx7�#s8kZ4˾�כ/j�Y���?0�H��x߽y�#�m��t��pm�����%�l����1e�[�&[¶��o�4�9������8tl�����Zw�S�b���@J@#g�N�#�R�?�-aZZ�U6�mx���9*�
3�a�X��l�� y�5�ES�U@5����H^�fV�CI�Jz��g�2]�~��A�$��ρ~�@%��%@6q��E}s�b�M6��Ҋ�[~]�^Ԅ�H�6U���Y��{A���.8�f���.!�j�B�"A��'z|Y1�\���X����xR�V$�6�/Vj�Л@*�tLlknF��K�"RgW��i�,Ǔ�\`�_�$t8���z���$Nz�2>������3aYQ��ԓ��]ɟEq�u�7ؒ�������-�XTS�A?0=X䕘V��Q��3
����lS���˥�`孀G�h��-x�T�&=QVâ*���;i�=o&N�Mضn�r�ܵ5�c��od�ٙ)���t���@����%��q�<[#�:4��h���;ě���Ἓę�D��7�y/���_�z��yB�M���kO��t�v�/R��r���a�����W1u ���R�8X���/&��=@;x�>�� _����=�
����$�-oG�'��$�l�g�_R�w�\�U~�N8�A4�a�Ud�5Ћ��yp�%���4�Ȋ
"i�;1L���2g/��`!�}>�/��6sC��Ka_M���1FA&��"��T�~��`� [d}���hɬN���w���pR�����o;�!X��âʇBѧ��l\ߠ[�x�V
w�ʕ�-��2�5�1��!�)�AU�ߣL��j�G��/��M�ĝub^�|�Š���� VŤ�Gʖ`�g6�Y���$wm������ �N��$	"]�o��K$,���>�!*Q���P��@=��J�{Š�j�gB�dz%2��w�贔(8���ǥG��������yS�u�v�8��	oW�u�J�� 2�P�d^2��Z�+��i��S�X��l 
I^�%g����by'��h��ew������-��j��îŵGip�9�$	p�:�IG����KV{P'lw5/_-k�w@ݐW*#��!CLYB�FR�H�%u��d�$4�����I3#��:X����w`,��Wv���xhP���+�%�u��ʽ��Il<��Nc����f��f1ݠJ�f��",���[���Ԡ�a�6m�<��^!*�{8΄_��"���������?}�}x�<�~{S����f8i���ݽ0�+eϑu#7�V���?.�����*�%�����fϸV_���˦M7j�ί��0D��~[��j��9��"wU��� ��l�0W���dwYs���j�]5Ǝ^��g�;|�=gӕ�y���#A��x��3�~8*.߮+EVC���0�:,��בZ�6O�&����ݺ������x)��0���s�����i�@g���âII� u����pN�,& ���ǘ�}���D��>6�]�̟���\̗���9e\��@{��w�h2�C���UN��UXF�G��&n�ƨ���=,�F�Xm��d��ק�:��+��C�}M�]˥O�Y�%��5��e5V� �Kx ��<�m�H��أOq��1��+l�2�6>_LFtƏd̶��pw����a�yq�S��C��b�>v���^ui$�	�I��	T�ݢ�GyU� q~�d�����V�����KJ_'3b_Q�p�L&�S�7P�Y1�&u�#��3D��z��|u���|{ӊH�QȻ=�J��ȓ~.�{bX�y5�fbzQ�MJ����˝�`݇�0c�}?�_o̗&�|�0F;��I���	>K;�y��e˨���#�$����SU�1":޿>u��w�?b�#�ٯ���	�A�WKUW��*�-ÄX�S@7�Ec�t�E�u���8ˀqG��q&��ndnQd�[^��#9�2)3�ו,���P��E����`P���Z,3b�!s����:��)�����QE���VY �w�srh�Ue�R?����WA��I������^͟T��������e��_�Q��j�)�G�T>Eu�����w2����ܾc�����RG�X,3vz�PMOo�g�Uޭ�kZ��7�+����z2 �/�]����C�k���m������+b����p�U�i��~�X���7닋9y,�3�$$�����4h��5�!y�2�i�8���"w:^>���;m򆶥�$���*є�U��d?V7��A��,Ƭ_`���ѯ���?Ɉ\�I��o�ap��KxgU�[��7f�Z�ċ�������Oⵈ��,�x�u+�K�χhE����*��3^�_�����2/�['��.���P6��� Ч�:ļ�u(ԃ������a��7���ĺ���d�[��&!4�`z�;6��k���m�b�P����ঠ3U)C��-vȞ��<a�?&#��HM�m����[�y�^r�;t��e�f��_�bP�j8�D.���b^��_Y�V]��1��Ǭ2b|<(�5#�K�^>��Q5(�,��ـ��m{wb>���+���`&�<=�s;	:j��VF�I�4�p0�$���65-��!��C�ڏ�]MvKŤ"&��~x��5ό����ۆ�df=���'�^K�����կ�L�m�d��9#�]E�;�b*�����뻍���
�����*��2���_S0ز������ e��L�&�_���_�Yap��v�>p��������2��3a͞��6�
	�'�r���y@'|�2�R}�|,3
QCy�����W��B9U�5�O��`]����ώ��-������!IΨZb�C���\���9�+�I�;b#-U��#ᐷF�;��a�i�l�U:�6���"�Jb�8�V�1ڇR��[�����a��4�<��wK����XAh[���*[��������ύ*��M%��ru�r
�V�og����a�q�τt�n���Kj�L��
P�����i^d.P���,z��'0D���+o���
ϴ��J�#�"��0b � k�?��%o?�A�:�e��,�z��(adc!6������L7��K\�3arA�s�v#-�ϣ��
�ꧠ��Aϛ�H�����{�O����@%�<�ԓ�)�z���P/Ӷh��	$�Dy_:��P�Ս��
�y6,f������N����W�6���+S���b������|���f�N�!����-S2��"uh}��\49;)��# R8����無��``H�nyT�2-J�6�r�w�{+4� �@v��|T���iL8�J|d�1���s3�C�/�ۋZ���J�=[>^��о_��v�!_�a��	Y���h�O���k+�����$Eɯ��k�y;��e_L{���ՠ    ̄]��<��#x�5?��s21(R>,)�n0�"�ʉc����̆�p����k�?�Á��6��s>p�7T��;-�y9΋�0����5��y��������hx�E��M�p#"��%�HM*]�즞7�E���Ɲ�;��=��� ��qUU�E��Pd(瞖���w�=��F���E�8�&)��¶�҂��K �a��,�~|��|T���H8�/B�_�����m����	����8��
"��觩�v��aÇ�8�^PW�@%_.�B{kr"5j,p0N3�]�$�?%�ALۅ���&U~!1_*��c�I܇Km�M����t������?q2�r�K���ΈgE��V�mq��Q��z$mČ�Z�&���.q���D�p�"/�~^􋲗�U9���E~Q��,"��y?Εu�J6գ֜]�,��m���ag��
;c�Y�L�!ęg�e��>����U_K�i�97�!p�)���؆3���������O8���c���qT��Q�����$ŷ�c?����Ǘ�;ڧ�5��ڼУ����Wn2<� .��X�Ze�!��& M �Q�U9�J�	1�(���;l��/:�9_;��&�<hkm���r�JHyJ���v����o���F�=ȴ�Z!�IUg�TGi-���Q���]K\|�\J
v�y��6S�x<�3�kp=�y��­Ў(��1�:����R`�U��q��{Š�e�2Ȕ�q��jJ��_Y�K�dJb��פ�HgI���V"�V8�t����q�q����K̔�y�A�va��<���~��L�$N	�:M����/;,�i6�I�Y͡&�`��,��V-b��1'��{��[e�)XKvՒ!�i+���ʥ1M�^GH��t�[����.?.��Ӗ��ܔ��ihl��#�R��X����jy@�������Z��ɱ���V�������?C����Q�*s7HN��l��m�XK�e�� F�ǡ�ŝ��UV��bA]�w���n$��7L���ץ���K��ȗ��r����ޯk��˷�y�%����Xc�����-��,���_�|�	�#���Իx�!��I��ז�DX��~%$r��̲X�9;UPn�b�e5��E9,3��[K<��F#�=%�X�k=��z�-�n�~�'W}�;���\��U'N*�nE��'t���ߟx�G������<�q}E�`]�ę���7�f����#S�\�+���b�t�Gz�b/A��r��������"c���Ӛ^���ck�E�����O`�	9���h1焁��!��qn�.�J.L�nf1"�Χi>�n�![�na,ΒPL'�|����D]5~B� �Mw�ݢ����m�
ö(�r�];��� �5�;�B��C(W$0s
0�+�`�W�� 9��2G�f�Gۃx��8�/]k���xh���=	e,�~8�YY��R�r��F��̲��<#E^���)Mg�̷�@z�L򡂌���FL��Н<��U�j]��/܃4^--����ݢ݆�3��;���((^�3,.��S�H�w�&��#W_|g��
L!"^�CUF2)S����+���{֜h��5��3��Q�x��)�E?����q5T�I&�����vR����ɤ�bJd���5	��Gm#�@���WOr��{^�=�{�![-yo�A�� �:���!��i��;[-��Z�-
��\�12]���@�;�49 LR�e�t�������%m�x,hHRl� 2)��� @&�g�t���c�S��A?/{bT��J3��2M�dH6Mƌ3�-�Fǻ��c��c
`L �7�
F%/p��``8W7l�
�]@d]y�C/[
Pkd�g����W	)(Q��nz�Nupf�Au��}�t����U���5-��v��4(PsV֐�����d:�#B��-�!`����˗��&�I7˝�4���TA
r��3�ϧ�9�Ȩ���3�R=�F��\���U��r�m?��ߴ�� �0�@���ҭ���F�*�Ӊ<m6"͗����:�b�i����G� ���/����y//�\T�I&rqQ�a<gc�hI�#g8U&�'�S�����ۜ������oB�[N]��?�s�i��?��LGG%�q��������qh&I
]�amA�C=����	{�m��~4VU_Z�"N�-�΀�F��6�^>�
Q�L�Ë�dD������A��]boj��Fc��VhE���,άI2�n��8����-�̽���㰏�y7���rP��5�(�<�(3���\=m�An�:��"���-~���#�;&CI�[�8���"]a��C�9�� ��KS��j���r}�LW�<��2���qO�#U���9SW5��-�K|9�H�IU���|�/DO�U1��e��p/h���;��'u $ 0�7$�� -q|�/��|�������ziB��a�\�j�@�ű��Y�*J�W��H\�k�A� �@R`��������kb���}�3K�:$p�~^􋼗�rT�`;R��������N�7��8y3�,�r3�,�<,�}���9��RҮ� �X��wˍ�Y�m��h�y��1�w/ەr�b"z�i��n���+����e�nt��y�7?�������}i�}V�F�Nrꛜ=��o=�@IK�ב|����ѡ= �1P�1H]M��ke��Ίp�1ع���TCQSm�Z2
/�,�:&��A�8NQ�j�ZW�d'^�/�T�=*"�:��Xy��3-��� Ř���G�,�x�dƘf��|��ӊG���:������#g�qߖ������} � 5X]�R��Ó$#�B��H�B�:����-%3_:�O^�s�F^�rPx��o{�3�*yd���ɢ I��KE@C�DR�~vx���&��w>�/�r�������V�a$ =u|���a��/i7T�`Ň��x�s�)�^�'����϶!e�F���:��*"q4_$E��2����Y�ЫQ�}�KK59@���=݁��v�����uՄ��s�?d|�\m��Y^�J}��K�)�6�:p�P"M\#n����je5p��X"�����g���y?u}ɓy�����LX;���e�-ޖ6H��V�ߖ��GL��6L�aѰv�o�q6�rw��I�$H�C���o:M2�N�̊���T2��UQ��2����_٫�rQ�!#C͐��0 |�ǻ�p�h�I	�Xp�8�_�iL�={'=:h�7�YA����.@����/���_��Ns��ٜ|S��-+�j�v�/R�҇ͺ�w	����M?�=��[� nc�b�4�|<Ц	�k�x;�T;O��V��b�����:2:l B�~9%&'sΰC?^�T�b�O�<�z�N�u��R�5�����U#Êݮ���3e�uM1��q07վ:8`�|֋h���ӗ��+4U��m6��[�ݶ��8b/=��HI탖���M?����bЗ�Í��-�#|�W8��	�]૥+��dk�.�T5*7����2�I��= zl��`�5]��'wY $��Ȩ�I9ؓ0��X�{�x'�)4���K�P��{:�L]��3��ʃJT�8PKl�C��:���N�M�Z�ӳv�So���Ɂ�`z��s_�79�Eǀ��K?g��	�.�u$!`8G,K52�H�8Y�UC$���pyy���",������Bֹ�[�w=�����W��Vb��||Q��0#\X�G��FY����r'?/��3E�z�*͆����/���ܾ��;��ޣ�D����K9[��uX�}u���1�,��2=���6�!��k��2���EOmH�U����5i��Iܩ�wO��5��N׺>�I˷�k����<0�;����O���f�]��U�V\��U��S��h ��q��͑���<��.�wD�M��g�'c�#����%R���L�O�	��.�T���ݑ����x;@��O�U��}>�-���Ħ��C��\5,�km1�r���d^�<W�;$�p��{��z���jt\G*!~L�H��W�}1��    ���������w�Q�h��]�OF5�X��H��'�ѳ����&\"�;!��� �L���ɡQL��ł��hIU�A�Q�f/�
��<�8���r��m�FN���,`���t}�!�E�;���}��C�K�{�Un���J{�}7�M][>An����Q�6&a>}wX~q�t���1xh�x��2ڮ��E��W��{��DV��!��Z���JS+��"#��)�)�_�Z�����va�m��ݶM~�[ܰ_{kG��<_;�p��5�ܠ2��|>׵m�N���pM������+D'#�rq�ah��`����A/U���q&8!O2t���Q)�S���R�����sތI!F��!�U�ԙ��Wz�`Ú<an,���\�M�F��rE���`��|��8��1��+C�Q?�]��,�_��!o����������Z9� }��M��b��[\s-"1g�Wxӷ�k�W�z掤�:��8F��d�r> �!������W?�;�Y�����ay���l�����{�7��8����A�Դ/8����M���,����'����O��8�ɢ%{��w8�V�C����������;
�*4s.��w�3�[��u�C�8ا!l�A�l�}Kp��CJ���@�~z0����>�M��z��f�a�W���>9
�u��m��M��
b*u/�B=�T����KP�#�1����M�E�,����3��%�A��c�p^<�BY1�Ke�8mR�;����_����~0��-�"�(�?�)��P�\��MVlsŪ=��I�����ůWs�J�ݚL�Ĕ~�j�!em>�TH�9(��Y��'�#/�u����Lp ����]�xW�'O�֍49�!��c�y?�
QFհȄ_��<C�Xi��;uu�g���d w���n��RIH��Ŏ�������KB˾'^��]�����k���RG� !+����^>��qUBB�˄Ld�����|Y1mI�	k���=cB�i,1p�8 �K�����*L�AO��RTb"��T��"#���I�Lt�g7�'�l[M�~���ɓ��1a�4ĭ����%B����l���c�=v��E����W���`��&)@� SM�#n�7���W~k��k�2[�� ܉�Za�0coy���[�wX_!��'�8�֯�2�\�@mSŭu$W���� �%q�;-Z���W�F�l�t�@�DL��c� �[�N:9؟����%@��h�o9]��c����d�x2v�odSz$��bq��d]����Л�;L�$ڸ�b�l��)X@g�y���iVΣ�|�sa�bߑօ��5w��K&��/`p���7��b�Զ�u�_/��O��,b|ڟ�v��~�;C����̟�:v�W�}	�n$�7�/\�2!8�I</�ɣ;n�ō �ዝ��:`��<�z�q�o�*������A��U�0��r4Ȩ��#Z�<�tf��D%�����X�������c��a�dMn[�B*9�{��(;>���>狃�W�'�>�A�8<��تKޗXy����'�ABW�Kʶb��p8�&���H���CUm�9Q�zzsDBf}p�A��%N>Em=�.��R������"�V��QFݼ���ղ6�9u���[[����Xm;�'�;�b���x���ؐF���?C-���ӎ�Ky�/̲�7D'=��I���]�Wi(U���v�Շ����wHĿS�;ɿ�8���~GX��2��.�Ԋ"�A�5�ha8-Y���E�(�<��a&��r<DZ�����+�h�뉧v�_0����yrN~<�۵�ƛؾB�&f��Ec	p�j�O�q+��N���Ѐ�eu��o^L���A�U��E��>�K`r2uC'=�y�l�R)��{i<�Ͳ��W�����V�:��a�X�7-;Ր���|��w�J�+1ʄJG�̓_d���L�fɓAC��i���,*k~�����1��VF������j���QK���+����]�o$Jʊy��¶ꓺ����!�c=�ڣ!��BU�'���"N��{�2á���ht�b���#	�_磵k.5��guݚ��c��'�)dy�b��;�E�ͧ}�(�AU�+1�D>�(�#���m9��ݬ�_��j���^lou���#�\�w�q4d'�gyL</!ԁ�A!�/[��gt-�b+������s�����Dn�e�R&~U��=R�չo�p� ��lK+�F�ՠz�����'����y{L�mF5�*]"4��%]`o����I����������@2�|�Z,�TQ���� �,�J���4��[}�ݟ+\I���?d�p�{NO���B��J�0By0g���8�	�PKE���dsO�}.𴦒w
���		.s��*��,`{��iT�-1Ӗ?Ƃ*?{y��Ţ�J�����Fݐ������j��p	6N%�b� �Emiusn �ӷ��zp��n�:���4~�������.3��5�կ�Jnuw��^|�2H�j�._`�������<���s��&���wiv�j�]kj��J#��O��;H6b�V�]�ƺ�n5���1�=�j�Fs�'��Xd���Y� J��W9�	��^�x�*S�$� f���iO��`Ty&�x�����l�%Q9��gk�$-��Ś��[肇�k����2~B3���m����r�0#9��ج�Nm�)�5A$�{���n����Gz���T���]�%y��I�4t?V}��a;f_���u�m�*��n݇|�_jE/�5��_B�w_��yx8��`pv�4u�H7Ё�qn�eSO�u�o�A/���_��v&��4��p~�}�%�|�v�/R��ͺ����Y�ĸk�Z^Җ+R����_�+T �wE���A�f�o�8��A�5+��Х�������3�3��lw�}F���NJ�.�ey��{��̱̈́�Z��gy׶�L�So Ǻo�ג"�Yx������	K�|cނ�¾���+���y�w��n��κ1��ޤjW#Zۚ�АC������E\����W��r��m??���=H���EF�_�����,�nw�nJ�E�V�(F~,^\[�w���c�Y�kW�m��J�gtT���.�O�hz�����}�2*�B���~�f]����nW��48"�"+���#���jPV�a&��(Ǔ���|3x�}�cup�`��� �?���q�2f�y�5�
��Z�w?_(�����9����A�Ln��-���hYn�5ƻ�ȗ�F�~�f^�nJ]c��r�h�X�/5}^NGp��7^Ē*��A)��ף�K�L�A���ȉ��p�&����2>s��7��!�RMފWj��$�4��N�#b�O'O�MKU�1����Q�[�oOz���;�A�~���v�%����c����=HC�qsyХ3�a��m�%�����~^��i/�`P�#�ٞfZ�w��(�<��)h�1��ΨW���|ӓǹ*��� K�La��U��XJlw�>����-0y��_�~}2`����I�������O2F#fWXB?�����9����NsϝrW�V�-�;��kF�L��Y�E�eSEҩ�{΋���Z��7�l��ˍ0�"�8�K���������D���چ�;�;���ҝ�6��u
qmLɣ���V,H��IU�l�.��g�*&+&-|�?Ѕ-)�{�	(c��4�r&k8%�I�4]$.��%bf02�G		��ۻ�A1�f'�J�]��)v/�ޗ��G�1q�z3þ�����e%�U1�D^\��<C&�Y�Z�фO�.��R�f�R�Ǯ��6�#K*I��ޢ�LEd���b��Jĉ�|�
ňh�|K��_�v1�&�*#�uA����;�X�Gd�'�6h��Ah��ŴD��+��^���,	2Z9�O|�Uw;F��-S��[�뢼#���������}g����{���n��+�U�'e�nu�.
�]��ͩ@�/��ޠ���j0��<bxQND�(�̰v(���Tt�|:e��SJ
R2OɤM`s�!)<1%47     b��A��߹�wrR�n��D|$o:�NKa�ѓ�C�ǵ5R덛��x׹XȝވN�\v�B�:ǌ���Sן���,i��9~<K�S�!6�PK^	�����r������9b��w��i�X�Y��s����ΚK� �K�b����[�n�sd�7�]�y��]�����nw���Ç��h���w�'���}^^����{@@;a`���kadA$����MV���������Q%�L w�Ȉvֱ�Q�� ��lR�r�ޑf�ɢ�)�H>�l2c��̦�����NhA�E�Y8��d^=�` ؟J���b��J0k� �J��=�哪Te���Mр��z������#�F�͞��gaE/s� [���(�V�](��_K�9@��~^��rmWyQF2lOd�f�E���s�)�h�g��eNa��.`Q��|-��N�����I�(;��ͨ�0S�D��sT���)|��~�����kC��?m揷��;Zc}�_/����?}����
,���J#Ԅ�3�@{���q�+�����!�wy1�7���nw5DO.��A��c�H~��GCCw�cMj�u�ɍ�
�㸟O�Ť'&U1�ʱ��4)� ~�c9��jf����CV";)�Q�rr���^��w+m�M�?�.�"�齧Ͳyc���"<9Ha�0����0�ϩ�1���;�x⏻�L���8�QѦ����w�c�B�����/[�v���IUm�3��}�����?f�ʧ�9�[V-�X6�1E՜��@G#v(OWsZoW��ڥfOBP1��g�ݖ������S��tG�v�x��g<�t�>�ѱǗ�H��-�
Rr[~�	�x���@��	��ݢ�b��\�����,dt|�צ�\�-D$�}���L�WаҔ@�-�p��,n7�Ȼ�2��8��W�W~M
`��y�_Ա�Q���SL=`�E��D�B��9zD,���E-/�(�����Dmz�F��������عt��JD��7��RD
}��|u`M����`����C��o�<�@��}� o�B1�n/WCk�3��u2�<F��(Lxj��^(�O�������jBc31�@
��$be��Bhk��E4��0�=�����(��n�')1U ?d��f����HY�G{�ې�X���s9t��UÐ�=�KCV?�cj'�]�H�I��ms��\>�`f]�	$O`�H�9!�DE��D����Թݞd��.	,�
�V?e=�m0fMgc�3&��HN��Ӯ�B�B�ta\�r���Œm����m^�%-1¹/
Jp!W�m���dNm^�,�>��>��\7���i���jl���[C7�S��ĀI�gD���}�3�bF fr��Fv������Em���Z������NC�kmL�\g�2�h7�燇MCk г���"��xK�g��(I���M���xYJ5Ny<�4��n8`�n�������^G�4R��<�|��f�!��z����M�C��D�9K��,��	1�[�yc�؀��?�d_�8�٬��D�Hl 2/:���Y쭬m_�S�s��
2��̩���7��]��ԉ�|S�Pd��W�k�-ᗔK�ײB3�&`��#�O0��F��T�]�N偰��y�M�=/��15��m<�>�%�	�j��	Q�B�	�Q�=�=����/q�ߔ�G4�v�՘�Xr;
��-D^�^�*�(r;�3�|���c���+n�5Yp����0��g�����BsB�TiE�y��f��ރy�����`��\�t�egM���Իq�K�y$w��劎����>����\���#Y�F��fJ`�<�(�����rLD���Ė�_s"ԉK�q���k;8����B��.}ZvI2\��g�����NY�[��UWdbt1����-�6�2[wTv;�Y��msv�/���;�3�I����KdN�^Q$�����5�ڌ2������FV����:1�AѺ6����z�q (N�1�e��Y��+Ƣ�s�8�ո3����$h������5��R4�Sa��s�]VK.��,Y�22S�:�̋QU��^?��菆��.��S]�1��hIj��S'U#��qL!"��s��*��ɿW�ń �NǾ(|��U4�xp˛L��l��HxOp\��ɟI��2����V�0��	�(��m�7~��aN�&����|�)<`MU��5���<X��Ǘ��'e`�"��E=|��>��v�G_,g:Y���X�G�H�*��^�.���w �пq=���I��|r�V��f���Eǂd�E�` �(r1V@zj H4��|����|t�J��MF��l�P�b�	V���̽S�RT�~Օ�l��?.2W+�7�R�[A�	��͓�ҹg>�����D�x�H���^b���+��d!٭�00c�(����ϧ�?{�c�;R�+2�܊�E0��]��K��A��[-,�y�n� ؗ�V+#�z�W+����X�&�8R��d9;��%g�4�z�;Sf��%�O$P��F��r��d�P#�C��t�bf�8�[�1d���C�
�'5N��.L� �z�+Ι<�O65�}��V?�|�9��2����w�OP/���D������R�}��Տ?|R~��N1ꔣ\��^�*��_��"#mqdΕ:c�?,�S�=�����Hм���vw���d]����md���L�+%����0Jl���Д�@E��Q����zê7Ў �Nkx@�8�����j�����LX1��J'�p��XϹ"3$��:�4�p����l0�1�i�g��k��m���!�6�{kw*�4泸�fii ��ځQ�"�Oq�p�k��G�S��o�pl������	@�ZB�t��JE&Dq�w3��� �H`L���C �<�O��c�'�I�FHvS;�!�,ю�֎,�ʽ#��Ÿp�7E,��=]�}z�!Vq|6#��Q�Y���]#�IWR��eW�&�����˂��g���%���:��Ȝh�u4X�H׍�NQ��|��ʳ��|ԃ<�L�K*���i��<z��<g�?��@/i��`�42�Cdܕ�h�s$�5�@����$2O�pU�Ԝ	�;���9�<t����H�h.-����'��R914�-�'�W�����9jUo�U�7H3{�b������7ʄîx�[����,6gw�'��OX�q��ш7�=F� �����8�渴ɟ𖡾A�$	0�@�˚Ƶ��E
g��zIl����$#3&����A2�3Mւ&�L��0�fp%�GU�W/�������*�|��&$E�3cb��E�ǧm�@V7���x�i���9��j��c�Ǆ����Wt��W�vOx�&��:�Fz�x$��~b�h]~�@Ĵ���!�v�ǭ�d�o��������v�:�q�hB���{�m �m�f�}&�"YN�`��}��i-!���Y��jz��}�S5��.�kT���C*-�)���g�>[
�U�ה"W�<	S�Z��[-'��a���SR��`�k^����o�	�-�)����[êe� �V�!;���*|���jI���:���`]�^nC#��0�Sa���$Ú�"_� �6���p?�QN}c�C}�Ũ9*jO�ꘛ�N��\�25L�2l�"� ����l�3�-v�2���'�y�\b�x����&��_H=�`$/�w�_Z�Ѳ��&%S	�d�Z����$�έ䤖�E�-��V>�2��C���^��� <�E��u�E^Ui<���i�*^�ӑ����Ȼ7IۃY�YF;�[���Z׵��� `�aX���~΀3�_�ٖ�bX��srr ���3,H:y;1DIs��B�p�4��4}����T�~D��X!�'�M��F�
Õc:���h,f���f	~�t�It53I��S��؂4A�:ܶ��S�vN�U�/���%ƒ�����t;_�=GH������^���߶��_O*��AةkZ8�+���D��4����E��c����}}zH\m��*/�N������؆�����F���B�5P9�    W3u ;��θ�i�%q��E�28�(��?�F #BE/�����aU� ���Ã�KG�M}xo��u���O?�@%���-���\�����:3���ꆬ&�ᯯ~��Sj	?j�j�6}]��$"�r�٘q���+�뀤
���6(:��-󢬺�ꖙ(��q/�!���Jjm8�Μ�A�A����~}��D�)hBԋ<:�M2�I���-�K��ګ��0��Z�U���8���os�d��TM�{��w��;:r��Ÿ�*��J!��~������Q�ܴx�����*}�J�n���ȋ~�/*1��H��A�)�ghf]�6�M��^3��A.��̧��������[����F2M��P��rh���`�!)�h�.�ra�s�f�1��zOPH�Z�UC�O�x?4��Cu�9���yA�5�Z�v?7ef͋T�ql�our����L�b�� �V>}��QRJ[gn�\�_�_z���`��>��Y��.���A��`��"_
������۫���s8��F�=�q	p���w<� 4J�����9W>��(Q�oKft*Nw�z}	ctw�kA�Ie��wD��n�+�b�	1��G^{��<׍���t[Z�Ʉ���$���M�7B���N�L}��[m���K0��mzc��^����f�M�����>Ua��T{#+����j�odR����;�Y�o�����4���׫կ���[CXҕ�cї%@��<Xk;����B�W \bò�㞪��n7���E�J��_ۢҔ�����'CoK����t��x�?h�d��p�\�a,r�8�Y�,�~�&L0��0����-l��� �M�Զ�s�S�R{y�~y�=���eoM>�bIJ29��?ba��@�����y6�E�(��@�����:��aX�A ����3%�2M�(-c�h�:�ہN��c��g�
fMQ��%ȾI�>Sb'�A���K�M�D&C�P���a(�U9 Q�.��qF^I��6�d���T��K�c�;�|�:��#l�ɢ��T ������t�b���R���R�Ja���Ok�=��Oџd���#Bִi\�I�p�H������m<l�G��e.�L�;y�el�u)����	�ᷫ�\~�"y�eq��4Ʌ*��ǘ4-U37�N1�EQ�ê;����E��~��M���n1�}����&�-K�Z���a�5'Ӣ��.ЎL��tp�Š*t�:(D�R{(� �S��R\��tW$#b|`9�YY
�-d��D{Nɔ߲�U��tJ`���ŭ*��X�+P�. �o���緤gei�w��bC�W2��'�r� u���>�<�G����q�<����c<�'��E`ߴ#�w�"d�i�ѩ˷ ꐟ,ғ�N�@�G�#湦�@Yd�A{T\t�ђ�(�x0,H��C6]�L�;$���'꓈����\F���x���p�8��J\H�yj�'�d���a���VWqc�lP�O�ßE����(��<��L.�H?�J����B)�[�I�wqL�m�s\軡"�f�~9��!�_QE�(Ë>����8�ޱ��M��^�M���7���.���oS�c��g��K~�p[+���`����k��cM�U\�	P�r��ҮB��M�CW=���|/�ܦ#����~__��9��w��G�{�~�_��� ��������A^������z,˞n�%q6�y�*{H G�?�Q������'�&�e�&1#F�ލ��p��77��P�3<�V���b�|�иa
)���U�ڴ������!�� ���qp�)���$��Ot�qGr!*Y�u����S*Y��}�J>����c
���i�d#������~ &N��	+s�w� o>��<˼kW���nO�g�C��۞(*�;̩2�;�4L���[\����+p�U�Z-����.e�Y>����?~��{��C�M�IV���]]}���z�VfQ�����0�/2���N�|�w���:W����8�����}�����T��x ��b������),��-�
�������a��e���͑&A��c$K�J��byns���(��7�&um@��#N��G����j��ߖ{GoS�J��K~7����l�y^3M=ꙸ��8-"�YL��F$�*��ymf-��.�*�3�2&,Ѱ��:</�(>zu�D98;\.��ٲoZ�-{��w@�谙}lq�� �I!�X�9Ir�4�[�jކ��'\�r!�j�]G �m�$���9�qǋ����]�F&x�xNP����ˢ�)�MMH�:[	3"�n^��_T�8Eq1(�a�l��|t-uvʔ��� ����՘L�7�=��k�����F����?@É��v5�-�z�N1�4�pW�a22�!H^�/$%&6}���\<�B�+��	kߒ�[�5�Ni�8��j*��J�!C2]�����,�v���n��D�6���e�� 2��Y�d�qD��D�Y�2�`�`��xڷ����T��z.W��I�b�J��U'^�z�"�՝}e<N���؀A3���)�0��U�A&Dy1(����X�M)Z��Y��0*��$�d�X0�e���@�ppQ�פ����=A�l� �%U�`8ROM�����k�p[���� W�'k$�|O��dr\+E��(�l�o�kBk�.���ތa��*kEpcǾ ��^�.��i�8��R)E�x�X]���¸��Q��9�\��ܬ�Lh7�:���\0�U@�A\{�̪�C=�a��4ou^�Gڡv%��F#]|1t~3k��Z}e�k�_d�IJ�\w� ��mI�8J``	�,;x����YJV�2d��_녯"��[�NCCBW*����8X���ܨ�~����BE-c���{'��	�y�2{R �Z��d�����������zZ��:U�̿[�>�҉��f��P��C�ӂ骂�AiG�B;��y�[ӹ�낸���-�����06�&%�I�nEc�P��C�Y��s6QK�*I�߱�[3�7����*�)G��a�L녢��'��;���·� <��ǭ���G!��L�R�d��ڷ�����k��o�D��.���h��[b�1N�t�9��Ӧ�)���%�)i��s�9�{��\I�ad�(���wlO�@ˊ[��V����>���Q�W�:��Ԁ]!@���@��a}v�V �A��b�\~�}pN	�7���i�>	4�Ts�ƽ���ӎ*�
��O��7�0P�L/`�[����WEC�َ�CS��UNP��� { ͂A��+*g�Kh�h�d��czdY�.p�x��~�~&x�3�I���e�,�yzG�Ӵ]�9d
�h8���.���܇�P��$���fBߖv��~w6��NR�{�Ԁr�"�������}/��WC����F�?
����7�_n�|�~�Qf'�v*���G+�X3bP�5mS(�]hIC
K>�Ք!.8�Ul%�{����qLXx�ZP���r,g�"��^s��n��pEN�wm�>r��H����!G�5%��Vp�"�uD�)���VB	E&ƲFgD�a��c�>��\�V����R��Ӡ��E�8{�8KZS,(�w�Y=�u$t^�����҂��9��w
�#	��%R���`5ς�b*5�Y�X�g��|�x��,d�G�����&�>�X�|S�dm�7�.� ��W��9F/��{�[�[���٨����M��WALVӍw�/��6Z��(<:���|���է#�AmP����ɥ���嚷	��:�UX���u!d�@h�UE��mp.����P��Fq���TmU�9�R�f��"{1e>@��"?��X-eѫ�g�{}u��m^��kb��;��#�	���Ϳ�%b�}4�����{}��]����u�#����Z� OsIFl�'Н���A^�UWT�a&
q1EFqW_э��9���V�f��F�D1��|L�a��w�~.FU��,�K��DF��fl	,z����/B\�i
|�Ex�?��2N���$��v|��\g�I�JD�a@X�qi�<˛�"�
;    9�.�\.���X�p�I�m[g10&�`8�V^����W��6�W_]*Ń�e�Q���z�F�/�5a�e�ʀ�ʬj�9���o����o垭���ga?W�%��
*����e��(VVt�'^�g��݆l�#�,ʌ�M�`'H�Mk=s�v������ ӝSη��j��ҳy!���_��|���>�hPH��F!l�f�ȿ�Ȉyw��{�n,��s�f(�wC�i�0L�- Qv�>�JQ�e&��b ��?���ә3���ق �@c( ,�Ώ�%2[[#�� �-�̠���^�W	��	EO�M݌
�=8������5��7� �`���'g��v�����P�əX0K�����"�sװ鿠�ӓ�j�Tu;Tr�9WiўU���P@]�_nSB��J��<.3k����&o-Z�Sg�AV|'(��#�?-�+�ڞ�!e>�8]�G�&f�E&���������OefzW;{�c�m��\���`n
�a�.�� �WM�0�������]jxP�r�	����Fpe�S;�@iH�U����e$E�q!f�q9�J��� ȴx���x�rT�FX�g���ۨ%4�ƶKoj�E���V��8�b�������F���988��A��7��=�S�.�T��_�D��0r/!�[���>Ԁ�#.h\(0��G����+�����٬n
S�ϰ	�7�r���ܠ�$��5��M?�a�$-��;c�Y�*��\�$g�d�����:(�"�_G��c�[O�Tj�3<-�J�����w?|��e��O���!�An�y
���6�P|�s���քмˋ�l�b�R/r,���d���c�ʆm�@��Z����UG�!������ܾ��_�����-��e�'����tu)o���w�������hk2�M����/�������Q�gIXj�y:��@�bٹb�5?n�ɖ�A�VQ�d>�%�Wv
������X��2\�"���M�ih�e,�	b�Iی�/������e�PPjLC؈Y����vX' ����H�Q��
����V,�����
DB���z]������.��) �؄�N���M�ՙ5{� ���ޖ�� ��% ��5�fC`��jcLzpU���T+)����3-���R�L�Päҁ��$P��[��=�K�-�D��{�JD�{	�W�Š������b �Y���X�"��&��v�	�꺤�V�Ma	�-A�l����@�j������m��g9���
��^E��%����ץ1���%O��jͼ/]��ym��w*�/5���SS���;X��׳B�"G�v��X�_���	�搊\�~Q�Ǚ(��Ve���Q��@����|m�7B�6<��q=���Y��u�<
� /Mu���h:3�a�b���O�p�|g��q�ؑA�h��{�	��a���GX�V��h��a�4๺-(��Q�{�
��f�l�7r���г�S�9����u�eg�zm�"Ue|�?�����av6���a�����H��:��/�4�Hmn,#���ne��ࣧ��"N�Y�����QL+�G*��9��>?RA�]y>H��d-��9�rrv��%���xI�%M+��m����vi� ����6�i�B;��
K����~q���_Lm�e����R-wb�<��*��ü,����g�{1�`�����Fz�8����~O��)k���Tj��8Fet��TP��5�m���={f!�6OzOX�C�y�M\�zN_D�t2OR�P@�+��N��Ȭ>��s��]R�"������ Op��a16�Ia��8Jt�\
�(�ُ��r���ve=ґ�i�������h�'���K�4=�?3?[���IG?�%������2�X�U'�����Q �L�d��W�;ԝ�-䇿�������L�]�O�����Z������ ��Lm���:޺���K�`]maE��[���&��
b�f���X�s����r�̟t�[�׫�U�S�Q;iK�WQ���#���9���d�7h��H�)DG����WeO��Š,��s�����I�|��A�i���]��M�x�d��i���H�[G��!�$����'���	�a ���'�a��:CM3�����is$�0��a5v&X�	^��f����NM���/[*"0��d���Q�*��;�Pp-��B�"0X����'��W���: �[�m#��
P�l%�&OD��b��c6$��P�A:�l�A*OU��9�fI�lӻ[��7$�G$-�K�ϐ��}�)��|2S��6�ZϏ�v.��uo�a�)�EGMD�EY���f�l�"�F��_D�W���8��X��dKWvM8b'� *�4r�q����%!�sB��a^F�� �؟�\�ݓ95�s�|�{b���΅�<ʉ�E1Db�ҏ����e��8W���nWIzfxͬD���M�b�B,�س�-{̿X�u<�v�͐�>(ܔ1þN&�����S��tI��<d��	-�0�g'w����	�__ ����>G��ōx�b��H�#L�}ѝ�m0x�#7�tY�J�&��B������h��t��s�p`Zʰ#�N1ʋ����(��bP�������%�j�vFJ��
��(��j4j��b�l�y,�^�g�v���2����.��豣����&�V�f���J
	� ��Y9R5ft�`��X���aN5�� �d�����+��j��Q���V3�� ��6�dy�'od�,'� �B�(���&2����X��/:u=G�� V&��l�աM�H�Ͷ�khR{el�t�p^���g��,�f�d�_5n�*$��ٯ��]�7}��d�O�"���!���<r�쾨���f���M�=������V��)z@E]��S�3!zþ�l9����獉�r;.�:����v�z���#k��C�A8)�q?�XP{$���$?��\t��z���2�w��G��#7Ҩ#���V]Q"]����7*��f���")b����n���0|{�{�65��ܦ��M28��1��ϭ�76O�c[߳�˂�K�k}�a/N;ǚYB�T���@�AH�I��݃W��P�>Iq6NL\��8�[�H �G���0Q�'��%�S�u��Yޒ�a������1�o��J�'38:81u�Y���y����݄<%5�X�^�w��G�T�V�7��[�:q�X,B�x�:
���B�Tt��{=���{��x�"�����{�u-���e]�D��g�����B�,/m�PUpʃ��ބ� �^�>���볲({�f*y1��q�dB�0���ʷ�a	X��{�ڜ�*״��]Ҥ��?�w�L�/D;�����)��n7Ǎ�g��<�|cVB�0���%m�D�vT�"8*u,#8��*�D�����U,پF�r��4� �O�wK��B�kЇ�ob�ǘ�EP�5�	-<�������O�Ơ�_��m�Z����{�҈X��Կ{=�%���~ݎ�ɹ�bFP��1l��/�%�g�r@�J��M0d����q�뜛��{�Fh��Ȩ�R�/گ�.�#m�
&U�Fl�� :C�{�;�E�L���.bt'��a��yl��-�����zy+���K2�sd&�)Ɗ�ԫ�A%D&��Š�f�ͥ� 3!�ϸ��d:�Mܚ�fx�`����:'����2��o&�3�1tK�6[@Ϝ;���lS���:�S5�>���)S�2���#�[���my�ƞ+��`[���qo���^���n#b���!~"ů��b��I�FFj-۶�yLm�̡���y1t������C/�$�ӽ�U�`c�a�Y>�]9p3�r�$IJr9"�!"ܦ���A��-����ml�b?kjB�-�eW�$�n=�C�P���x����A���CDqbF�aY��Wm��:�P��J.��V�QVB��Ϩ�y�jQ���!��s�Ks�)K���:e�=
/շ��8���_,;zl��M2�0\�|�eg��2��ʪ��@?�@���H��H{�� uF����3�F&�gRL�`}�KrM�| l�I    ȳ�@� ���^��Уܱj���LD�u�|���O>�>*I�̐I�p=���0�z�����"��CG]�l��U].~pd�<y�=��� �%c�686�'�\�Vu����0=QMB%���~J��SC>4מ,{��L���dJ���@x2�@�v�aG�yѭ�ê?0��A������NXC�<�l�S��wF���N�j��Y���8˙��t��D�_����EG2� ��U�n&�X�Ì8�g>�T���׮Sɋ������J�}W������v
1x�&��A@�y�C��SO	R��W��WN��
�ڇ�%_��f"��Ļ��V��5��ݍ��AF`w��n�q�iMV=��8�M�I�ƍ�%��x�4�v���ێ�9y���a�g�R��'��8mG����<��`�K�v2.J�x1z&��2�PB��ևh�'3��Ƃ2�Q�]q28��r�l�-	�ɹ��2;T�˷�K�n���
�PM������~�|�]�������:7��M����/�������Q�K&r4&P�N9΋~U�J@�w1(G�!Ɠ!_fߚZ�")4<�g�2)r�"���^���M�$��*�2�o䍕���CQ4�M]Fn�P��дK�q|��[8�)^ jkM�"��d��}w����=ώ��n�ɷVT��f26NiSቔ�����0v�V���xe8��2W�cK`t҄3�Q�VfG��XԚ��	ۗú��0)�d����狳�Pq�c����h�z�l)i˚tW:��͹k��Nܜ�8񂽨Ib��`�����Q�e���	�����4�W��,�0�Ll<ZS��
�5<�`g������(�bd�q�g18�!'ӈ���5�TW.Ub�	1����J���:��bAyB�5g75�R�;��^.�
(�0�J��n�Ӕ��GW1��8ͨ:����܆�1Kjю��ݸ��N��f�G<Y�2���菒w����N��g8�������}����;��{X�p�k(�Ѐ��y
��˭��B���?�y�MmK�������@xr��	Nc�N�"�,WϹ�%��M�����	�ɺ�9s$^/ѹSR�w
*"�Za �f�����
�t��cQ�BM��v���~ �^Ё_��SQ�a��KxR����3�j�z���Jk}�]�z et�(�y!`
wd��!��t�5�kÒo�L�x3��3"���d,�}��/,��;�.f��b']'	j�o��s� �G���L~�!}:�͡�1ɕ�E�[<N�~_=��YP�z[�
�{o�;#��,�l �e�,�����Q�uf�ۀ�)Φ|����d$_���׼ι��e��:m��K*ƛ�3y0ai����9���l�#�±�h8E��v�-��{~�`�+��u	'S`M�PWs�Qv��r�G�����z���c%t�}��Z}������zw>���s=0���t��G`7�K���l����u��.հ{��r��eU��݋A���p�}vO��Z��jw2C.�H����Q��ud�Jt���zr_v30�yQ����ڀ�Q�}˙n�}^�#�#�)�_�����e�_����o\Ͽ�����P�V7�]b�VXv���o�{� 5��t��M����j�4f�\@�l�[�A],p�>��s�������$��ML3����x֭/��*�O��E5߾�aN zq���lL��%'N'��,�2��,87���	o*��W�B٣�Sna;�����'��G6:'�/��V}�8=���C�7Sw��`�d�*����I�( Y�ΐ�VS����B�_:3y���Ӯ�پ�}�x�r_�(����}ɷ�k̑(�N�J@��'Q��ː��}0�-�թ��:h�j2����vdwQ�rO��7�O���#%��؀�~RP�|�(�E�xn��z�p0�B�<� ��	�J�^�u�n^�U�WCm���e���	r�A#('�C�S��I�$�"r��z��܌ԹB.z�� 8�Jy-�p����(�i7��2dk���ye��2P�e�-��7e��j���4-����������
*�>˘Ĩ�qr��a�#�HD��ܹ�G5������d�&y�@#;G���ӳ�4�mdI�J]ﭚ�1������P}�������ok��R��f��E�~�
5���� �߷�܀� ���
���F��k�?v��]�(ٖ�/�'���r	�z�!�>U�/��]�Im��hH�����/��X�X�Q���Ue�d��g�Yi������0'���������p�TO!W����S�a,Nf�j[�+ڒ�n��5n ��'!�R@�N��B7IA$���Ր�Fg��=D'5�j����h�S����^���1pL���$� �A}�FW�*������{��5:��˶N����9{g_]��͗Kz��b�:.�^��c�&���K#50'�? Bʬ8g�x��/>C���*�=A�l}x��g0n�4	n�^��T)��!�;�}+D%��/2!ʋa�L��w�3_���?���!��/��F��Ŧ�=���]2��\�j
�\C
�Pu`��xUj�޵4j#F/�����Ar���D)#[ ������Y���
M k%�`1͊2�+�O�Q��`͗=��q��v�܂�|yD�mj[w�	{�E���C\I �r�E)S�o+;K\6�o�<�HQ��^��Lm3��Z��#�Î(:������f$u/��AF��:����3���T).�T?�7A��p���F�AŢ�@8�5�(u	
d�e	}S�����b���^=����j�ԬvO��F��VOɳsc�g���N�CC�l��!`�xѯz������C�-~GU���P��]
�N�� ���ʕ#����3Sp¶��:Ye��9B�lゴ�Zo"�&`D�p�͎]�c�g��,°��;�Ht��
.B_�U� ��M�JsOB��#��Nd�8B��;��g�W@"����/��mjf<-T�r=�ooC���f+}��VQw#�\� ~Xަ�P�d/&-�R"�76}�B%s^X�X�/��ڝ�Gx�8YR����r���W��~j5)[�%?$��<���z9+�F��2�(�J���Ƃ���6,h�g+td-�e=B:�(���1�rI��eQ:E�Ss1���bt1��3t,��ƙ�#�yAL�Na��`4��\�J�h�ݱ��#�Ѿ�,�j�E�Y�����A;
�"��`�l�$#�ʩ#p���$��\�$�Do���K�#�N�ȋA%FU���X���͜��.H,���8��w^�]��5؞x|�G��!)�ik;����O #�%� �k�s9��afQ�>��Sg�B�"xk'1(�l\L
�I���~F�I��W{��������zո�[�L�L�^�{{Lq�T��.,�dx��NH�\���>\���1�+m�����́8j?_hm:�S>��aH�������F�Y����&��Ei�1�2f���u|�)��4nXuG�(��V���S���e8�Z�@=A�� i��I���EcSx�"be��
3�K��ֲ ��&eZ���+�np�鞾�	Wyd�ӚΙ�k2��l%��V�bnZ�]��贃~ѱ5y��I��D���6�����H��VPN�ӈ��u$�O�"���n��y?�4����x5z�qkl5�mi���'ʳ]��:
'IkM�1y�v����I�:(����pny?3��q:�vذ2�o6�D�}��}Q�q&
��2���k��K?��t� %n�B�I3M_�6%c������K79n�HΎ5�yZ�n�Π�lD�ZoÀ�p 9��w�:'����HZ����n��`h��E��S�^�m�P� _�MպD�)��\�u(J��j�p��h�5,T�,�O���T���Iq�\��LK�d���׀逸DB�v�`�F�w�����G'��A^�r���ʍ4��Y�C�;�!�e8������/�Б�M�]�E����A./s    ���M�x�Դ��.΍1Do��J%\�݀-����+u�׮;���YKP�宅W��w��YL7�F�veT���2�ի^m*0dx��dJ������c1E�]��.�!�Z�\
W�AՏJ��P�`�w�Jӆ���O�.KD'�iLJp�#/-��ײs�ℴ���H'q%��Xo�v9�i������D�� �pP):�T�n%DU���]�㌈lrȤC�<�͕+΂��h�y"{
T��J���nA��Wo&]��%�)�\�M����x�%�M�_\���S�Y������R��	��*�]�H�q6�Nr�/~!zd;���i(�9x��c1ّ� dt��'h��k$p�tb�D:�ɘ��ۼڴ�3���hӷ^#p&��)��Oɣ���L�	ς)7D�S��n�d�J��.��:��} ��o�c�V_֟��-��Vky�*�D�:��7�TĤ���:�"H�^Ȉ����&oup���@E�s�^Mu�Kp��sLa�s�4�L���@��F����P�����^$C�=�p��=������T�ʢ,;E�#��(�~��2Q^zEF�^�%s�ڀ���s��+Ⳃ*�����I8Uq�Z���1��b�%m:�!��F�ph��2�>����O/ֿ���b�ĳ�T�,O�-VKY~j���;)o�\�6,���|����n��篶�(��O7�u��/t=�ף���o�;�0�k��yѫD�*`heW&"�͂�%|�;	�0�f�*��i�}Աg��\�m��j����o�?�_� �~����$�a�ɗB������U�������k"�hjI�8l�����E��������Ţfq"�&P�Dj߶S���DD�t'#X��1� ޏ���ַ�I
�N�Kcq8���U>�Z�w���7��s3[@R1�Ù��8O��$ �������+�[d�H��K�mV����ڋ�"��Q��~�,�a��2�&��x�;L�`�A|]	-Ю�T�E��v+QdB.�2�Rs�&����H���fB�5�PX�_�T~)Ȋ����������!�W]C��&��El�U�|�R�+�䆱���kLn<�ǘ�+���ʢ�"w��z��n?�wf�s��v-0�0��� ��lTV环�I����F�	���LV�I\��؝i�Qɋl�5���ݺN K%geQ�N1�a.�UYT�~&� ��Q�Yd�M����R8*L�� ;x��Wۭ����=�����0�
(�db�,����@$A�XL��)YZ����#$Tpbj��U�Uܖ�]lo��K����M̮I'�u�4�3�W���v�P:{c,�!x��DJ��v9�;-�I=�?�%��-^��i����k���'��@;��X��ũ�#�}	�f� �r�@�q/P3�8�Q������(�	?ק��#HP[k�g�-���-0V/N��S} QIZ���Ǘ�����Nl#ޏ�靊��*�Xj~6�dd*+J�<� �|\�-�Ŋ�B�i�����
	畞K�!{��z˭��;P�R�?�_��]Ө7շ�ܥZ�z=�+{�ժ��}%��1��Q�����&2���a���T�>ю���t�@�Պ�����`�Sbf�t[$4��P0�i���l��?w|�.�7RH��(�ƹ�o~�%���0ʋa��V����~F�Md��<�`T*�8��&w���ЎF|N+�|ięԵ�-b���Q)i�m��`&% �%6���qr��Jb+�K������h�zHP��C_�.{G�&6�ɦ��eJʵ�Wم���V2X.aӵ��{.� �c���.1�58'6��5�����M��s��(ݓ���D0��7л팪�Tw�A36�����#��]�ܿ�b���@ū��u�j�z��|��|�����\s �+�I��CO�V��l��T8)8���a��t6*��Ӥ�B�Ts�a؁�_�u��8Eq1�2������bۨ^<-9u�vP�o��}x�X&�P3@h���VbX�2��d8f�3���	�n�8Uo4o-W�PL{�<�o�DK>x��)�M�m:&�7��Znؐ��[�����+���m���h�l6l��<�4ݏ�s�"�z�Oɺ�]«H��I%�n�uCn�����J�/;���`{{hln���x�<�8�^AZ���MT����"`ߞ�=�,+!�9� /��7��2��Ao�������K�$�p��p�<&�Q5#D`��f�^����=��r���ֻ�3���
��r��,��`n�#{�C���+�z88�>�TR
XS���=X�g*����[�N>����T�0��i�}��8�>������M��?9�\|7f�Z4Rhb5gC��b�������^�]~$lrkI)vL�ċ��F{p��d��RMm�n) �B��1B:�-��\#ކXYS0Mp�	���N�ؓ+���C[a�pl�V,���%��?�43x���ضa������{y���]��N͐z\�V�¯�o�I� :�\���@�����W@ୱ=XŤ��/��^}��*�/Q�o���]4���յ?�E�7�v���~4�W�� A��EYêZ��Š7ΰ����ۜ�O��,Ԫb������!5R;m�,�4�s%rs�](&Fc�)_�ZX�Sx/+n��Y1�R������	b�4-2�?����E��I�jb8�-��������w��"���٬n*���`:��Z�k��VB&_H�]��L��"b;k�0�b�H� ��ϕ�\����������?/��%*�����eR�r��ج����u��U%c��\���u����i��*� 0J�~� �" Z�f1T�% �9n�G��p)Z��<�Zk��j��<1��Y%�d�G�r��OZd4���J�
hh+����d3��?<��lvZ(.VZ�]6L����¥�^�� ���S��q#�R�j]�� �E�N1 �sQV�q�+3Q�.}����k6���vۣ�;+���wrI�GީU�����L�]pn��4�@��JҲ����n��R;�p?5C7 `0c�Ԋ^.FU�_��!����Ȉ]F8F�mG�Z�]�ӻbs�O�y���x��%`����,��N�jXg[N��T��>�26�7��,68i�].���.��}bm�����Њ��B�Z#A�5�����8��\�V�??�g2�!~��!_�Ɗ*�a�M�ꎪ��	1��z7Lceb!%��O�����b�����X4qϭG3�ۥ�	n��~��LD���т�M.i�/�Y�8�ڇ���f�L3n'Q;5�� U��K��@)|�L�X^>�ro���QE�H���9��Ja�X"_�Ѕ<<e�щ��.��(�jI�*"�,�r�Z(�ɲ�ɂ[g;Z
�K�ʊ��z�����62?l�ğ��eՔ��Y��� ��뀖�!�sCY��p.e�X1����Ӛj��}�aK�`Hu�p��"�|TE���1Y%|���_�Op>���t }��Q�{����BH�"/��o�E^U�[�#/�e6���q,M���pa>a\Dڑ[��Ϝd�4�-�m����6��g�.��6�A�̄ܠ�ϱTI���sǻc����i��r/3��Q��IIR�c'Q*s\���'{����$G��S0�j(*L�]�i��~O<z$�6Gt�?��fb����.�~FWrg�\ ][e�ʎ������ �+� s�v���xK+i�;F�;^�j	m��sC��;M����.␕k�3}��)��q�����B45�`�⡶��[젛)�����u@~�Fn�n,��?.���R/�ȍ-�?acTKz���}&0&�;�*z>R�?�Η	�7z�)8�sSj�Qv�נ�䣁4t�y�T�ƴn��/��J�S
�.��J� �a��7G��J���X�d\�MAX�D�"Z3�k6D��^,�Qg'�VRlx�)b�B�`t&�5��-��]���{\-զ�5yf�?��IK������yd��KP�Ηw��Ί&"�L�	�G�1`��p:���/,�8�)�I    ],	S��eI�%Յ��h�:���_����z��[e(��Yf����@�IWΩK*8$SuFLʮ
"��3I �]^8t<xH�!��˼"��l�'�p����������z>�![E�1��JJ*��קC��?F\eG���4��+\;r<�$ 7�z��m☼�E�"Rs�V���t����Y��Ap�B�M�`�]n�
�h}{�v5&}�ou�W�\��n����	����?����%��_U�w��)�jS�=/�<��V]4y�|VG�.$��0�����\�q�u�0/FU���(�5㌦Iz�$�*�e�fb�K�={���[q�6j*ւ��Вg�vs�b�P�L<=��0��?Շq��R��_�ƙ�������?���8�е䋶`7Y�W��_��U�|�D�ot����S6��e~�����|��1G���Cr-<>B<�q�5���^���!�����M�m1�?���V��F��.d�VV�_��Y)d$��猘HA}�]�5֊¿n�g�	-)���_�j=8QcI�xޓo���|<Z�r�j�Ʒ�}���}����NT�~7�J~�:X��<�y�D�B�s}=��9��>av�L�q�b��MZ�����}�"3���Q���R�����+��<��@������ɴ���y[<�X���
�3e-E�w�q��@Gy�K� ��/*1�Dy1��?��*Ы�p/�P��:�F/
���z,�f5�kt�%���Q� �}0��ӫ���zzs����B���^,W��.H�(_!�o�*���Ʊ����v$V�7I]�� b���l˸�:�y��1�U�,<�S.aJ͏����nQfo^�	I������LC�G@�^��S���A��9A�g��z1��� �nN!AF�ۢA"�Q�{��+����m=�X�j���Ư��QǢ1����)|�>3!0��V*Dv�[hj�oeT�I!7����x����
���6.����e��z��Ԟ��̗�Ž�?^}� �Kmط5�r��C,0�z���SQ���+��z-���l�v;�$d�d�V�y����X�w�{�PqM��7��0a�f�r�l�a����H�Z],�����=�T�_���z������p�jkOx��Y�����<�y0By9��RT�Ȅ^�#��'���vN�r�Yޅ��6�ۦ@�Cd��n���R�=��[�����+d�v�r5��I�������S��Ǐ�y����m�O~P���ՇO��yn»�I/�����#�lSg?eo~����ɠ�#k�)�N9�fb\��Z�>�ў&Y��C�������7�n^v��&,
ї˿��L9��Ǎ��7>�k�E��n����e�����E�7r{���~�[`e�%,g5	Q��D�S���� ޹zK���#a8׆�%��V�X?̶L&�͵c��s������h����M�@4���~m��dx0�-�1OI*�ߦ��:�44`}�7w�����I.��4|_�֠pgx�u����L�l�V�R1T��-`�-xr�}S�ܧ2���p�.8ؐ�θM�	��"�4�f�u���PcK��s�ڑ���;�D'�:O�;��C��@�_ê+2Q�� ��8�I�b)#:5�,r��1�G�L� �j�LpC%��)��ی|y�qu��ϩي���#�dZ����s�ђb�/S�	?���:����ʁE.F�Te)s�B����{�K��Aֲ]�r;/MŢ��6���f��̥�p��:���t����e�M��$�_�n���BQ�!jɃ�����A�g���Sִ�*�k�ąϣ�p�Z��lJ�`��F�{���Ć�iT��K�ޑ�Wv��y���~Kה�]�i� ���%�H,���M��y��}ƴᓫ���N$�Tz�ֶ�譂��Y�w�<�[��dbe]�X%zi�B�"%M�N���6����E�A����C�����?�~�����5� �SML}Pd��fu�P����LQ��dK\��@'�5��DC���Ԓ�RD��<�	3�'���b�=X8�5؍�P��ځ���+)#dy��������s2 �+�^"���x��N1�t��U�A�-3!��`0�l4�H�2j�,��q��Q��j��3��}r�2h<�djIA���F5C6')'"���ӮrVV'������"l�E�D)�g	i��\F����訣q�i�T�M�����'�`����c����s�Se~��;���⽮\�̯�w�,�ym���i�"�k#&�~zl	,V�ڢ��7�O=9<J����b��u^t�j����\��J��z9)�z �/�����Y�_�*��+ű�ڌ�-�)�6�ܽ�r�s����F>�^�Yݛ�ԫ�~9�-a��On7�
c1�8�0u)V�i�i��XS�a�n'nē޵׆V��N�kG�K>����I*&�$�q�T.6-i%�]rr�Y�	r��hƪ%��&��2	�fa���q��v
����*�3&}��F��|�pf��":Si����-n���:��c�?Ɔ 칟ΚAg���=�t��D�P'45e������ELe������Ʌ���l��?[ϟT��X�$x
4����/3����L�>'����,�`>I��N�9�nS�Μfgk�����tD�'0���$�%����-���s���m?|�6������2x|?}��e������ ��{�B��X/~�Jc��y�h��O]�jL3�H�S&��Dg�h�PF�tڒ6�t�É�1�kf��@o����b�P.��6�h*�QMX�ɸ[��<9$���j2ި�*,	ř2E����j���jNy�J�]�X���H��w���<j���7����GѰ����8g��o@���?}�T(Ӌ��2�|�}{/�S<3*g�؀K!�?��Na�k�J��^�	ѿ���I�7_3)$�m��(X�e�<��d������K�$�<�-����Qv�n.�Uѫz�L��E�T������ )����<�Y�?tT�;����4\�5H������q)R#�6�!g�#YF���$�d'�#�ۨ�YY��}�鑂���v�`a1��rS�7;�vϟLe7{tgm5�Ch�� d�c�~��5ݍ���ܓ8=='��_ȭq|T\W,B��4$�,8k��Q8��H-Zpi�|"D��$�e�N&=N]�;a3͈ZmHڕ8�8��@����Q�`���:�0EU�4��`Xf��ҟq�^��i߳-�G��ע����0�Z��7� �,U��/����-S�?���D����_��]�C4q��"	55�̙g�A������޸
>�0�Ω�u�E[(u��̴D��#;��ql ��I�+� `=;�I,�d�z�%�(��_�jn�á�a�c��ٸ��1�j�!�G3������h�&���D=�>�J�TV�w$�N��%�u�﮻���;�=���������ű̞����>��H�ˎ����rP��L�����!I���W$*�77k�**#L&�`}hbg�8�d3���}��?�S�L�2
�]��0ԛK6$w:Pi�e�L@oFeulZisU1��O�m0����?�_Ӆ�~]��J���E+_
W�}/�d�ՠ?C\N�$G�	9�b�A��'���w��h��b�q�d�8��5b�lN�)��n����y\ib�³.�?�M�I�dA�]�z�z��:��(�����0Ĥԣ9{%����f�.Q�� � m�!ޓ[!µFx�C7-6w�6��o�g��9h�+��B�:$l�+b_�D�O��;Xm!@�>鯾��}���~�4�q�� &W`�i�-M���?m�ƪp�Z##�ݩ������FhKw!�bX��U����`��2#,N����8���i��d� !yP�zf�Q4���/��\_,o���m*ߚI���#�~�<"������f8�(	��C�!	:��a� /ɤ�[�a��Vb�	�Z�����)�~Ϟ0�F�yj�i=�:��]yb:+?վ6��`�l����E��e��2��_���οYLUs�?kܳ    ]�2.LƯߵ)<�u���4a�-"R�" ,�a�@�#�UYVE)�B*��x{ì���Uy�%���EP��^��\�V�
�p��'a���u<I��ô!�G7\>|{� L�'�&�`+��ݙKS�BwL�gH�ޛ��:[�'�*�&}��^O�/�,��Tf`[�JQ$,�>��6����6�f:�n�z�+o)�
I6c�36�'ܲ����h�A�2�j�;XJ��J�ބq��Tx����\R8�}')����{��m���׬|��O]��L�7��%U�I�F8oZ�:_Ҥ㽼z���	�8�&TG�Jj�+kY|]ʣz��&h���g���ϵ��<^@�����p��{���y����޴&�`�~��C.?|5���Z���j#�Ee��b� �����,x)�jzr2�b��:��7-��2�h�NҊ��2�3�M��p�deQv;��q.UѫD���A1��څHH�_T
6�$��!�u�:���,w�F
�<����%1
�D{�'��'G��p&/XE^R�|}�д=~g�BǗ1o;&w% ~w7E
�����Gf�Ъ<�;��+p�g&ux��h�7O�"�c�GB�6Z(V�N�ȋ��U9�D�b0eD�/���$rF��s�NR'��m��Z��'�6�p��T����kU�7��rY�e�*F�Fg7�|���#��d��O�56�%��z�� �ݘ�ɽ�Xr�_Μ��3fd�Cb�`F"{(I4���a����eQ�˪?��N�b0*���CS�-K�� �~�?�������.�N3�ة�j�=�b�)FF�d�����t��^-��r�Ld�����>�5���~�b̢ů��Ƚ�Lr{�j����Ɵ��ZE?�2Ԫ��n����'�h]���`���� $�Sa�S�:b�B�[��L��`$ V��Ӹ���2��a3N�S��LjǮ�(i�5����t��4<�d
~�ɭ��h�i�`#�� n�F뛨>�F|�Ʀ��Q����İ8���*�1�D��) �Zh�7	5Hz擿����8�j�G�����Rx$S�!}�-ۻ�`��k�LA�c�p�Q^���W��L������`o����8�枯��ʒ�|R�li����O���W�
:Ք�m�x��n�/4U��2�
�r��� F1q��8�1�˚wG+��N�q��%�)9��ˮ���8���R��'�C��rv|�Ѝ�����Y�� �^bD�d.�/ͧE�QR8�P�6��$N͉չ�ȥ��oQ���y*�{mv�<�L[���/	E7��/H�l�SIc�)N��	��!��~ �{2�_$p��"AVt�ˎr3+�~Q�RY������0��P4m�D�_�!�d��,6�aC�D}��b���H>	�Ą<RցH&��F�LJ��~��ԥݲ~���5�[�sm���@W��H+��O��[�O�c��{Z$���:���	���L��t��Ҭ]�V�9(�Ϻ�ѭ�" >j������K �*�0�,�T����q�ؑ��<~e�{]�#�xW�(x�a?���(���[��B���{"eø�c3*0H�����t(�6�F���ɇ�2'[����NQcx5A�u���h)p��I������	$���E\�e��^��#7��yx�@y?eB��˷|&�w��} o�	����R>������������סc��M����/�������כ'�\��?�܂��9�]�V�PNc��ځf�p�~Gh��A��W���^�%�5Zg�
�H'd(�v�D�%�N��޴h۟�r�"�>�C����m1�b,V�uk��aHݧ�N����s�:�($��[�y�B��"/�J���Ȅ\�"s�?��<Ͷ�D�=�p�9F�Z>P��fa�z�MY��	M:"���2�r�8���P~D��pt|u@G��d1̅�$����B&�e���oON�	U_��+��t5��e]@L{��������<��n3m����&���*:EW��U9��c=$k���|Ҏ)F���p�t9+�=�Z��H�3Jgh5Z�E��D��k�j�ffM43�N�c���YE�_�4�Vg"����t���{��M
R�g�!�>�A��c�����)��*��T�tHw���%������w�����XU7j�F�u���Tw�z���/dP;H`�x^��Ӛ��w�e��j����&�/n�+x��?��0���ï�")�ȩBv�A&ǜ7�f�3���"���+�܏ڮڵ���n��w+��T&��(�$B�l��9���(zޫ�xlX��V���\u����G�SjL>EGtA�T���g1��{�iI`	|4S�_����oY|G�AȇH��1���a(�[�~W��{[�-��5ny�J�ly�)=d\�N �6���^�o,�t��
��LI!N�Ǝ�����X߳d�7��C���fqHz��\匲 �w�k�1�V֏V�D��MX{I�� Q��!풧��}�.��d��l� =S���4!�����:�+�{�e� /����|UK�@�K�b�^İS�U��;�c�7�:x��KP�!	>GRk"27��[�5L:�������D��8�78����7s'�\@��Zd���a}�b�X,��!$�y���xbW;�H�R]�8){���W]��bt1�3����/7B�D���lz3lj/��*�͡�>{�C�e�f���o�� -nE�ޠ��L�k�}Z����|V�a��dtRi�B�j�l ��_�{�?4��ڡ�2�|u���$Y���������&*�ϫ����,^|\\�D7jv�V�(<�XeI��gPh�[�/�4��?K��X��2d��.�^X������H�X� ��҂���]��a����va�p����#�[(�\&~U��4��(�}V�&<?��X3t�{Qv�!�f+�U��D1������F�9�ns�����6�F��#��H�`�`�W_.��.�ׂv/ԃg�V`z�U��~�s��U��5���J���1���$CU�^�^��:_��'��ꏺ\��� �hB� � ���8f���c���>򲨺�����0�o����ǥQ����ٝX}Bj�h��o����iL�!Q��mM�J�c!��8�������E�����C�y%=N3����æ����矄�<�ұ惚oj=-�ti�Ck�oGMN��^�\�P;�?�,kZg�OAo�����({����N�����dJ;�"}u����xӝ'�Tr�$�!���3�p�I�:��ڲ14�b��B���?64�UdolՊ�`����>2��t|��B{Mg{��rjZ<R�r���m��)�d��=�	6S=�؛RE�y��#<�%g�SmzP&��l�Dڭ���ȍ�e�}@��ŭ2�d�$v\"-B�C�����7vdS���� <�2�ʢv�n��Š*�U�	Q^ƣ��i�ZC�����Ħ�M�z@dZ�_;h�?E2�Q�g�|毭¶.�>��c��D�:z~�m��ޒ�KB�><�8�6cC[:���T�6���-w��tf�nE�X\4"�����S�W��'d�Q@�~���*��m(�{�Jc��t�`�]�ܺ�NJ�\Y�{�W����v/�����'��qtX�@'�dK)���t
"�u�L@LWy��v��Ӈ�o����CL�Ya�Z;�rl�`�R~�^rM-Tƣ���.O
;$�]�e��mR,��N1a/BT��kN���M�1"���F�y[���S�A&D�b0gD�Ԯ���P�Sy��&���.Y>�lۅt���!��{��GF�cp��|�qrJ,g���bG��F���j7ӑu��gR�.��j!n-��v���,�*�U' ��n"�=�E4�ͥCn�E��ߡ��K�VV$��T��,#�g���_�;�r��|�|��^�����y�:�'! 9��ݘ_�L���z�{or6�r��м�%��`�~G�N�ͅ�A{B�6�E�Q    `P����C5�ES�����4��0��6p�H���`^{�c�Bă��4��Z%��؇nO�����^m�/�4=�t����I6�>AD����>��/4׹�|�7z�����T��(QS�tm��"��ଚ��cƁ�ug����Js2�*%�8%��^�4��'c0qr���>�'��]Ͳ����z؅5���͠_��-�F�4�v����eO60@�������)�Z���U}����ߪ����`���޲5(��~}��L��}��ݐl��1;��0��#u��m)���%@��Mͦ]���z�/���5!�f+]���\fS�s�X�F�����^M�q�}�N��Hp*�@.��3���D�Q���(3!��Bd�M�7��k�V��ͻ��N2��t���8�`t�I!͎��0)�.v�&fD���G9�7�O����0]l��hM�=��Y��Y��o�ZW�P�����Ac��2�xځ
�>�lZ�f|���aO�Z��B�u��o�:��m��ID����<���#���>-^����4�>Q�)��T��"$�Lg��BW��p5�`^k�[�1\U��ΐ�g}�$�o�g�6�8�<��_�R�8�� �/�&O)qוllx��^��#��m�Ú֗,� <��m<3q""���Q�d3���$M�hSYL>�����LV�7���ȷx��{��c+ĪM����:��b�2��~k���K8��qa-����S�+l/�1����Nѓ��Ÿ*�Lxp1,ʭ��7k�7��Y��s7:��1�]\c� �{��������\�
�v��a�,�@��R�QI��c����НN���T�N_�"47�]��b,�ɋ��*q- q�fw�u���������,sѫ�a%z�����e�����a��l:T>�s����^0�<�Ȓ�E�;r�M�D�<<8�3* �\�~;8�>*��r�o��~$Ud�U�[�^�\���w���߸�#�E�R3�D�5դn���Xk���\��`��x
=�/w/P�ÁQ#���]V/���D�Z�~9iǒ-)�$�ձk'?)�$����.������[�j�!��ȫ�M��6%���*1Q�V�ɀNP*�q��J����	�c?�$�2!����\ijj�B7\�T|�Q�L�z��4��Z�I�5�r�sC�b)u��_���o��[^�|��t��^Ё_�Y�ʌ���v�߹�+-QG�̇պ��|m���L�Қ��/��^gfpƮ�U'��v��aA�H��93�rij�)��+�T%܁�2�-�bT�AՇ6c!��A��N� 4�>�I<-�Cl�a1�y�k|G6��UV�,�ع	�h<I���γ\2��}1j}R����o�|@;��C�O.�Uѭ��L��L���ʆ?]�o�Ј�ł0��X6��S�GR�,W�O��=G]�F��r�hǰ�f@�~uvyv�s"�'��a��
��.d�0W���E�t� LW�ܸ�o2�0�tq�)�`W!:���ݪ;����z�옂�A���T��
�K:�f8��똾����'9�A�z�ޘ;t�v�d�@��`�:S�Xg*J'2��Fip�7t�L���2԰e�zҎ)��RK$��B^5��j�n��G��RC��T�e��� ��Z�;�Y9��������]x�꓃#��@ K:�FMN���ݸ��}ٗFl�[&{�s��d>M6�����F���He��'��?�Xհ�n� �
����	X�o��_���H���k�|S�2��Έ���-��`�e
b��``�8I6;n8W�1ڌ���]�gZ�r�^J�$X�I���]{%��=������Ś8�γ����y��?Ή
S4z*q2Yc�4��T��������6�!_�4�<be@���.0���\,F�(�n���35=y��?V�.���MbH�:��͆��	te���:�����o$v�����V�e�&#:��h���_g��̂��-9��X�PVXB
P=f��E+��ivRS���v�O8�+�DX���Lty1�zê_hksQ�!Oh"b7�C}��x�o���	��>С��K�<�H��L����|�[�4c�gdi��#s@\��a�W��06�H[n��=�5��5L()ǖȢ�4b��!�w��G����$1��
	#4�����#�x�%�l)�M�&�@B���N��'����N��C`>�u�����p�������o띻����Y=��&{ri3�ն�%�}�+c;rޯ`��SZ��X���fq��Q��|�/�'�@���z������TuI��cd�ά�M��i,f��CS 8&��s�}�S�	����[�#���YLT;� �@Z���G!��'�Ͷ&��������������\[�4(:N+A�e"��yYU��"�VTY�u�C ��d���P�M�E��t�x��&�;���������C����փ:
6���B��
�F~���vy��k&���%��(ȁ
�l"�\��~Oq�Dq1"�o���d���A��YZ�+@���#c�Gqդ�}.��r�g'1rO��:�B�=��78��'�?��ַ�N��Űꏪ���
��v@ԼYۙ(�#z[n�:��P[N� YN�S�:�������l��A����}�$L�-�euG��&��~R�Gc�xW=g4�C��IC��C�EH�A�C�B�.Ӛ�ؐ���)�R0��Pb!�|������C97�aTe��J�����\O&���?�/�Q.	_p�A,��d��1�E'�Eg'٦f2]��:5��ʶ=�k�V�z�V`�b�.@a��r�S��㕻��J�q[���׺������苇�/_8�721�"�D��x�$Mi|I��i^(��&ߨ�_\����ud����2����Ly�G�i���Q�!A�-��{�BS�`�-ІF({�	��TN���z0N�C��	lb|�(N7ϙFLX�'��X!�heX���y�p�c�B�yFT����m׭a��sn':6u%
V��]feQ���TڳqU�ʿ��~���I����ׯ���g�3X"��	���Χ�W��Vt�^G��B6!��D!dddD�t�o�a�s�si�$�ZZ�"M��'��C�Gf�y����Gjbx��̣�8Y�p�;�*�NDW�	�_�2	qtD�@B���1��n�Gt����錔�^	i�=$��#�(f�tq@���'�t��0<T�cUF���A�Σj�
��$ n7�s�u��@�?�cMM}x]��H\��I}����h��c!<j�,xڡ��/Δ2�	� q��U�� ���t�p����[��^1�23_�M	s�S<�.��;>�L[�}����Ma�����,-��5�9��<v�a��;�(/���V%�
/�bHF��EpK�����'�I�Z����e�n��܎[ę��@�!cy�,� �6;g�A.ʪg�<�Ky �2"�!�?g���.�32T@r%���E'~?�CC�g�mFœ'�>�*���VEY���r,#�8#:�V8٠��ֺN@G�[����?K��5��9���cs�5Nfsg6hÎg�ƨ����T	c�ɫ�KJ�u{d���	Y,J�0�;��x���u�cؙӔ��(@�`�)	���~w�o&�Vt�:� lb��@�t�����"�p^aNtQ��h��T�+�F���E�K~]����,���V����`R5-�����0Mw��'q�⊬�Z(x.�NG��
��u��hd!C��f���n�W�Ь��(��P�Z��=\�BT4'2��R�pIY �0���O9�˲ꏪ�P���c_�݌�	w�� 6�(�bP��?}=sPd��pKe�Aݹ���b�ģQ�)�b_�^@�)I�n�ӑS/ݬ�M������<�A9����
e���*�k]Ȅd �c�b��rx��c��(�i_�$7���M�n�p!Tg\��7?]]��/�Ͽ�k��Ǐ�y��M�6��?������ç�G�V�����Wm�Q4�uR�����[���ί�� vH���zz:�&ږ��
Vk9�=,�,�%6d�33�� t��رf���    �l��u!��H98�6� @��0�4tE�U����bX���Y��tz4�$�NK����R�$0N���{D]OmL4���C&4oa��|+-z�,IuU[��a9z;}�En$��{��|�G��4H3�x��$I��0�P=6N	�ٲHp�	�g�5@�Vv�QG��W�q%�j�`)2\3�BB�9���/j؝�����5>��_���O�t�$���,L�m 1�1ƈ1���VM��
:e!�픈��P.>	 .��-��`�f"L.����w5d7PSݢ�@x����Nem�f$p�=O��:6�Ô�J	!�5�� 3վk����8�w1,ˌ2�f	D�v,��G�7\�^�����;
���3E���g&�� b�S�S�>�*-�$�f�KG������橳�`v��
Q�<��<#url��&�Ds����l��e�@ĩ�Y;�G���:�\Jp�M��Q�&��q�T��l�����9ЫrU����������i]���>���3�����	��>��s~��zqjҁ�1�\t:;��$_�R-ۯ�Lqy&�)
��w:��61��$���d�)�yQV0�n���1,��f�H��;D�x��&�8�����5�e�s�8vt��4j�m'�=5?�$~�����y:�}w����@q{G�V�,�N��g�
|��%~���+�vD�,׊Jt+1ʄ�l����C����m�9M�q�!�w�<�m��V�u�lfv�;4#��>I����������(�ϼ�,o���,�c�p��v�ck6,�����=����W�,�|�"��v��C}~����� ��z��"wY"wb����:�	Ɯb��)�)������_t��K|��Ȅ�CΘ����>�sd�L=�I�Ƿ��=H�%�@�ժA�P�C��k�k(��񝰱)C;vLp�)DU���ڏ�5K��ʼK��N�m��2��]-�P�,�T�<Ѣp�U�w{|���&�Ƞ���K���IG,�AF�����������L�w��l����P�w�����_�M������T��{�Y�Xֻ�hLq��;,�5fz$�jN�fy��}���b¹L��72M���!W)��`//��_V�2E�bX(�2^�G��Dv$���_�h0��� 亸`4g��a��q�B�$%#,���V��@1�q����'�z�-$�������(\m��{�\(�h4��5���<�s�"���+��W��m}+h�Z_�%L� |ĜI��@�T[LDp2.�]�D�h��O�f�aJf>n����u�U�~�q��B3��@��*^��
$g���3�݇7_9h�|��Jc�x�7Kӻ�2n����g�Ɲ������_�i�Ì"	?���h���3`>>�M���{5rMW*��Ӌ���S��V(S�_M ~�m�h�Q��~4�L�{��s���ڨ�I�zT�,�*Yl�)����|T>jj�eЁq�p�A4�+S�'��̦/:�(*$T;/��L�˛�X&�~�i�:��\���B��>��"E&,2���Yr��t�<��i�)��ĵ�O
�72�g�|�	N������ê��(�����,eWa8��T�L�$�ޜ˹�E�d�ȳ	E�m5w�\>��ك���˖��c�4�7�bzse	fڀ�А��ui�)x"Ou���������?���FW��$�g��E\,�����jA�����y9��ȋ� �c�6��f��������h5(!eI��ǯ�;�poc�o�6��p���:�p޸��x���f�4q[��e1�~�^[ ��5�9aop�D4�.�N5�e���%���|�Gv�TM%1؀0K��>d��ч��(���ߏ�ڹB%z[�hplhp�����@�����j=����\�߭V��?����f��)������^ڡ?xc�[xH�cMg{�譤�uNw���=���U��X��FK`���d���d�Q �Q��3M�@0kի���#H��TK��K���s����*֥+t�G�b���W݁�-Z��n�����;�����a\Ջ|�^F���!��W���,t{Q�wdQG���6�����N�'5���bE+�؇Ք2>'{��Y��^Y��=(�E�땸�v���X��i��Y`�jٚ���L�(c[�X�5C�ZȽC�I��u�!T�E���(�I7�'݀&[�3�x�#$g���2�ۄK6R�c���F7��Oli�-{r�f��οX8�t�	wRa�|L�.��IN� m�dn%ٜ3ι.՗���2a���{$�ﮮ���T5�
�:�R��z�<������ji&��F�"�1_t�O���)���j����������_2�}��(���Q9�\Q7�/6�b�_t/�g��k
*N<���s�I��Mu�������I�td.!�8 	%�s�P\�6�d; �'ým�$d��ϖbE}\�
H�ch{=������Jq1�_XyȐC�{P�~O"�{Z�!���T�p5aǸ�z�~^���Ue�	ѕ�t��u0�6ics �Q41���	~���ê��8:~G�	�2���W�~>�!�Gy�~�ZưQt_m/*@b�P�8}����UfRfi�� ض�����պ�<��FVőS�qOb��� �i%�bz-��V=��~��c̾$�5��4���-��J6q�5�8y�	���l1��ڃ�.��\�oƲ~�o�?࠙K�{F�M���ǡ��4tu�x�_��h��洆�\��0�"R��*we���喞��Koc] O�V����|�㲽�wwOO���_�����9D�w��G�{}N~�_��[
ʞR�=�N1�E�*FJ�-+�^����h��)��,R��$ FULP����/dؙ�M'
4sͱ=�3B��r��ec�H��Y"��5}�׋@���Ύ��ʱI�Mtؾ��?�M�Hz�S�r���.�
5�<��K*�����#��b���I7��%h��^�����,ݐÉˢ�Ͼj}�;3m�� �_��L5�D!8�]<�Ov�?����j;��<'Z!�U�Vё��
jH6"���%0V�
�)�{�J2Q/�=�6R�!����O�4_HF���U;y�ju��7]���������t�b*�/KŨ�^땪N`#@kR���Rfǯ𕺖���|&��ۧ�C��~q-__���	���f�]7���͡��m�!�}���Ssyʮ�ɪ�\�k�7��ōz���̟���+@ R�W�}�}9U<�/�yosN<I[����X1�:��u��AxRK'0�R8[��������u�{�nZ�����K~7�ⶭ"&OT�6���Y�6���q&�������^�k��HP�����P����1E���|�yR}:c��,I 1��m6��U~;���ʻu�+>E�շ����"�1ڰ^hf���P���s�YkzH�=噱jџ���UA���!^A�s�3�! Ė���fD9���B�-H��K�����Vv���9+����Q�e�U�����������kn�6���G��w��J����^��8�z��O�y�\R"WbV"U���ӿh 3JZg@].�w�"�3@���9������H�M��;�ZmO�g��7�v�+}����v��9-����B'�"f�e�.��":u����Ha���]���ig�	@&N��	8�Ċhy�>�<���6�e�� �<���}ɇ�٭ƶ�Ӕ��� M�jf�Lןd�P-��&x�؆ɓ���Q��'�𓦝\K/�N�+z�V�M.��t㐮�b�իN�p���*U��ݿ;)��jG�ė���Z얆!��1Z��v%R��c[�3gν&'�1";$`e,���?�a��H�);yq12�|$#�ёzN�E��Nb�Y�,O�x�ZH��z;{�[�|ㅚҞzFK]��ʘ[Ұ��`���3qI�l�]�Ѧ�]��!���VS�X@���T��_���
�"S,�#(uBG��9O=�S�a	�4Ҳ���GY҇u�vY6?�|p��Jt$F{�׵f��&=�5e�Ѥ�P=.��r0����W�=��^[2    Z��}�6�Ż�̔�.g�%-�7m�U�	e��n��{bO�������Ed��>.���e����
�*?��̢AK=�P��p���/0��do^�+1���4�t�����A��Y����r8gN!77����I
)-��IH�b���Ј3x.4�7*��g�"S� *�,�W���S�����p$�|^��CYS>5z�~FwG{�$k�G}˽�w���A���w+#|�����'��}��M]%)�U�Rw�@� �������٣�c����6�*��m�4ʋ=�μ�縇5�R��i�����ğ� !��L<� ���9��E9��<���p�n���]��e��\S-n���b�
n�P�aj�n`t�煑ԬUl{�Z5m���G}W���VWu^�����J�����ee`�y�a�ñ�C�`]y%P:��?a��`L,rn!��7g�׭Ҭ#I*
At��iT�V)HR-��@К�W'B}ȫ�F��Q5!��������/��x�� ۀ.����;8��1�(W`�;�#����B�����\��6.s���\������#!�</�Ü�4��`^v���HW��:���Ǯ=��!Cfٳ�c1"�m�t�D�y���	����a����8������r_�ɱ�t�$�2�ުC2�Hii�^��ʟ�f�V��������e�o�~��F�B��-�H�0�	�Ӧ5!��o?���_����"��D�:�6k̪��ؼ��4��J�D���,�y��yyL�i�tU��\�'u؁ZQK�^I ~���f�QY�t�N�y$j���ejH���Q)�PC�׸��]�v�7��)��D_�|Z���<_���8�_�A�Ba�4B�$�aLg�c.X5��#}3L4��A8��H��!5��`CWm݆gL�K�8��N�?Ȯ�J�V��zH�WT�g�@/�£M<���ݶ�E��q��� ((���#&B�J'4W���u9���Ȼ!p>^�yu��q�*������H�g��j���*�,uغ��e�^A������eī~�����I C�2���:,����MQ��,	L�-е��̊����a_�~>�	�m�[����p��طZ�� ˎ��@k�e7�:�[�`�q�k�e������[s��ku�h�
ڗU�J��J�3��(�sJ�@#߂֊ �*ֺ3nP( UmfZ�����aw<�^0�����]�J��"���u�ԇ�Q�4B�e���t��f�����OGx�)@��S�)�@�͵&�j�����"+�a�(�cZA���O>���m�3��������N��������%N�.�8F�F�7�XT�T<ЈK�wBn;/�b�?L�%	l1���(Z��J�ߐɓ��&z�Tɦ���q�p����;�Q�J��L�{;�i��I"��FU�^~�Vj1�E�4Iݮ�~��}
Re'py��Z��m�>�i��f��ǜƣ����䝁���(�b��G}1���R2��t�iF�k�� ,M �>9�[��y8�|�ؤ��5�3��|p�MnNf�
Kw�����e0��'�|����pT��LL/&�!�)��&���L�"�4���_�2Q����p��}�T����z��B����Q���C6�;q�a|z����	ߚ����jN&�e�a_y"��RG۬��6L$��d YX�v�ʙ��W�(RqX�V�a���W ���]/�R�H�?�E�(s�_��EH*+��m�qU1��0�;�n����N(Ј�C����B,�;ⴱ�Ԥ {l#�F��E;b�`q[�0Qc����"����
�8so]��5ƒL1���1�+�6;p��T\�IR>a�����Zd<2�0�B�p&�]���)��\�����ē�ɇérU��F?��6Q�y�h�y?�3E"vR�L�dA�z�w|ؐ�-�?Our�nղ+���O͒�f��Bj��O�����w۽z�\㷲$X���(���NGZ��.�X*�~>��(�|\�<B\L���@�ѫd��x�5��Q?/�Ť'��(����y�'ݾiP��2mh:AGR(�~+�UȨʚ"jt2�-Q��f-�*������ �P�D���asĹ�.��M���C��=���	�*��&�.v�+�@��n���6%�ƽ&��Z��t�P���Ӧ�1�̦�v@�U�x�z�4<���9wV�#��\Y?6s- H������t#�i��h@�;أ� ��XZ� ��F �EO޼�Si��q7�� B�aI�Mm�����0���<a���U%D�|�L���h[��d#f}YĈ)����L���ױ�{�dq�A0�M�1��Z��Q��ѷf�u�W���l��r0,�4b|1����F2�3�pS�0~�Z
C-�
���-,���]檪lA�1���J��]9�yNt(��ʼ��T��{~�spM!��eZY�z�?����%t���#De�#xG�@i��Y�ZWN[��C*�0#�eWR$E+�5�v�\~�3�|��3���Sb�0D�_^3$�<R���='�}�aɎ���yp�3W�W!�|`�nw��3\Yb� �Ó
;�7�s
�b��?��K�]F�.%�x��Ha�>����hv�� ^�H�b�	�_L&"C�m7�11��]^��+F��hrS����O9� 6O�צ��g�1�V��y�a���${]�.�x�QE~?��0	T�>I�D0/_2ׅ��N:�	�Ya7�\�Xv�����^D�[�kh�5S��y����'�n@�!��I9��w���[4��ͬ�����1`���p��Ч�_�"�S}���pV�q�^.�T���(�ru��=\?�N�nu����V�J��>�7ךn�t�v;i-�W��v����*��(?vq�ԍn����_�Oz�(G�r�g"-k�T�o�=E�n�Kއa�ƺ��������y<q��D��-t����c�����=�t"��|E�Qҷ�+�Q������?痽�,k����2�&c��,ܻ����eC���\����S�����O,S�Fz���Kk�x�
H�z68�i�������P��J��K��W+��������؞�rQz��,�e>֖��AF�U�(ۖH��\I$�h�)r`2�h�0$�& �DdF1�uq5����ޱrD�^���q��y�N�2i-�Է7^\�s#�8g7֦f��"��eI}�G�_�7�����͞��i_�@}�O��L���d2̈� �ST�����Kco�,8�P-ݯ��ўޗ*2��uS@ƴ�����uHZh�,�,W��Z����uu^?���x���˱�5���Jtn��\3��ݍ�Rbp{����!�A�!�B��aSϲ���c��:Ⳋo#���q���[/�P�P��E�W{��� ����b��R^�R��l �_��wgm�#Q;����`�k(<_��%~�'��˭�T}��ܱ+u�=��|��8C?�s1�/�����A��$���_aS1.]�2��[3�P�mL%���<5�6JV4gaR����~��XvC��K_�DZm�dhy�\h��	�|��/-E�2���Rv�6�,օ�ɸj�%�0vD{��E�5��*Ll����Z,F�Te��I�ԗ��#�h�ZCH�ҜLycR厫�F ֋jo�o��ru�m|�[`�k��(�V��fRC�`2m
��F-l�/��.��;�ʞ߶3po�V�p��M$!�đ5�xr���Q�.�h���9���=CY*����r4�D]�q�=�����ŀ�d��X���ڗb�*9�1&��<����"��k��{�a����r�y�X5r'�&����!�*c� �'�Q����l����u�o�x�	�촔���"C��~",l�XTD~]qjh�J/Sid�o�
Jr��-�Z32�؊\k2���쿟ϫ��aq��� �ZqU�R�O��g�w����{u�h9�6O��搏�HF��΅�E��2=!J��Zy&��b�����Jl	�do�    ��K�\i2�{@��,��@�4R:���>�)���s�����TY`-��'G�qv����5K� u�js�Iԅ�D��v�	�����^��Eb[�p�B *A�������.��m�9c�'�U�[ZO|��-+a�
�苼_�^1(�xu��|z1�L2_���'�G�l�2��i�=������Y�0`�- cG�ZϦ�?ȃ]���@�
�d�0��<��z!�w��n�p����a�*��GY������C��X�QH�8p��={Y'��n����W3�ͻ<k��I�X�n?ޭ��W���+�.�F���)7�ճY�����U�������64�p�ٹ�5*!���H����N~�<@��,���/�n3��eHݻ�{Ko��)=���YS��>�H�e��,a�4��^�H���s�"FI�n,�i;�e�K�yXK43��Dr�,L�d���� �M�ۍB*+r1�烾P#O�Y)F���d��.}��ɶ&AԮ9�>_�}�J���ԁ%ޠ`��$������3���%n�<vX�5<i��A�N���9K]5���|I����~��B�Xp*���éaF�Z)�)\Ԟ �2L^���Z���$&S�������kPjI�$�1L��ı��`<>.#Ʉ7J�4WZ2�!߹�軏��L�lT�z���Xs�'EĐ�AfO��W��
�z��G�Z^ʤr�P4p����Y(�� �I�؎)��~Fu�6���D1tMu�>"g�8z��z��N>����ʶTP��p�(�i��)W���ڢ��台yY/V]��+#P���*1:|Pl�[NDX�,9+G�H��xU���2AR������]��?���CIQ5Obd�b���z/� p���+u���"��-���=��� �|��i9#�YF�nq��^�Tp�}TnQ0�/t��â
���K�{1�*:O;>9Y/�z�%}Կb��cX�tY �rq���F�#��E�,��\�G��?���$��ە�C��ͫeo��Ϟ�T:�yo(�f����R��-�fpTJY��i��Nf�!�S@�^t�� A�q�2=��]+�iW��_r�}�Hi^/��Nx2��[��1�Y�C�n�an:#0a�ۨ�Hdu��i[;��q�h~���'���NO6��Qpi�9MX	��ȴ�AXX��ޟ���*�Q~�Qz]@��ڨ��lFtmA�p�Y�cj��re�4��r$ʁ�v1��E���P�hDK�ُ��>��x�I|s�@��%��g�5틼���S��B�w�flA�	@Θj�6H���K��:����+~�{���	�<��n����M�5��|���r9U�C}�U�L�y�@�x��I� Y:_mAM�EB�T��	˽vg���~�KN��Lʍ�U���h8���l�=���1P���^>,�q)`б���ÌtNP���D��[	y��3��XZ�kE?��iO��bX�c���r��2�t����Ą
��b�:�} �l��α#���F`�b-��Ԕ���_��/��[;���^���4�当�q�G�>	 ǙWi��z����Cuiq���9d����<��7 U]�\�VXjX�E��������fds�B�J��r$���#g����\�UM�hc�fH
 \�>�T���U�\7	��1(G�jQ}���\���m0���巒9�C
܁|$����ڣJM�N�BtZ%+/�D� W�H0c�g����Ft�΍���g�Gl�cG�[ȄE��Y��9����Bi	ԏ|����P�:)��
uH��)��u%͓P�jY�蠢�˱zwk�p�F�������թ�s��ޟ�ۛ�w:__�{�~ST�.��E�rB��+q�(�C�5��gqQ�P���<+O�Ε�!:�,}:wpf�
�
0���J!�9� c1(�S�˺�q8��:����VLD�,;+�<�z��e�gB/f�8�@_����V�⣦���s/�|�/�^yT�o��w����q(�[_���3�+�������>�S���T��������>� �7�n؇��k��,�������½�z^=jh�`�^��f�&[��狢���z6nM�����?'7�_�j�;����*X�����Ϣ�0���^J�C<��@�C�N�z�9K��Th:�C5QT�A�=��C�#ܳ׏t��}P!�Y���Z�\4|%���D��Ɠ�h<��'���<�t6��N�!���X�'gp,՝�I'3��p�/ߘ��q8ƍO>VyV��my���U ��q���Q?/�Š'�r(J!��&���O��k��sN���٨��|��	����ͻd��ϭ(/N !�I�(?�L_��M�trۍ�³����[�u�B�[(�b_F!U��Y)nI�7OsⶢE��8N✃|�u��"٣?��ZX$j���N�\p��Zs�}��N��x����Z���Kn�0����J⌀�6�c�����Ow2�w�O��~3{͈��j��_Q�DBdӻ��n� j+�!�0�}=����C��kಆ��I���~��#�E��TS��B�#����4�t�~�R�巻mdA�^Y
c}m���
�b��ĄgSuO�'3.��P�SY#�^��n���N�w�#-�׳�e��.�W���rK�(�V�	qE�����/F=1(��{W\��iFc��������S��q�?#�Iaq��$·���?�«�K�R�.V���9�v&K#X���`�p��>�ǫ�ZTP1���J��R1g���LVs*�\͞x	a~������p$��CMw�M���T�i���?B���]U�\�䙰��_4�+��l5WC�|Y�i��h?�U�z�5-��Ӧ*�`O��٢�P�a�+d��fR�t�
�Q�:�d��~XW焽[C��Y�.���(:��=�1iX.46v��m��:.e�EMɰ�@�)��<~��u��D�����K"�+��'}@�EO��AQ�L���d*2_����'�v����}��(�t��L���m;m�C)�f�!�ꨄY���e��<`�.��Yz=��M%%�����H�U��	vP	��i�
����B
���Q^�����4��( �Wi���p/W�g���3ʘ}�,���'�ĤI绞qB�A�<a	�����ݩ���w�زm#�Ա�q��z�3!	�
��£�k�k��p?/Lb�V��U3�[U*o��Xn���J���z�R���]Ǯ�k�o�l����e�HS��:C�#|[����硹�	'&�b�dY��ς8&���g�iP��j��ޜ�S��D�;���r8*�LL/&�AD�B:�u!��2'&�����-�I�}*，[7�z�kIE���b��O���)H懖��s3^�qQg���HLf���!k���Ÿ�ҳ�D��G=1)�aY�L�@
���x`¾�}�;��*Z\"��I��{B�G���~�+���z?�*sl�o�I (r��K�\�"�⃲w�����	R]�ڤ$�oD$�N(��1`����E��l�f��nu�[���SM�V׻����L��7����|��ϫ�̲~:`:�Rl�sw�)�+���'�u�UҬ�c���$�9�N�x����rp�J1�����51'm����Ɛ��O1����T�� �M��F��J��IX�YBr-�����k]=�lYȀS��ړ��D��o+�o�f��Cݬ�+ՙ������e�Rs¾��L�βоV=D�B�����Ru�Z�*-k�
��!S��������2��,_�F�э3O��ȃ&}�a�7@�BA�E/����2!F��(�f�����,N[A�s^�H���D�O]:Ъ������n�9������'�ؖ
ǂ')�Z�f�@nc2�SRMY�_҈�'#N�{j��s>BuVę��͉���(V���9���Q/���i9*L�?Έ�D��K��L)ք��B	Uu�A,(�߫|o�԰��V]�U��I��^��^���g ꟸZq����m@i|�$�M��m,�K�    �^F�`B#n��#!Qι[O;18�;,s*���/�������J�Ժ��Iu)6��c�*2���t���`$��~je��6&��d.�/CҨq�-5{"���L�^H�zQ���ƑG�w�K5�U���P���7�r�5���Q�c-�P�/��3: ��*�WI �F�9���;��b�8j�������0�1wK����Γ3��9��ov@t�U7���6bOR<+���s{�Z9ID4@�����+OR�p�r:ʍ�/�`�|ar#66�V�� ���<2���@F���HK�H�}����I�/=���(�8br1�N3����{���vk��%;�4��I�
>v@��j׀�a�6�E#���ܥڲ
X�=?�&��?l�v�tm{[)�oǴ���]@cW� Q�˞qrLo��C��&1��6���M�<��T{Z�\����}�8��H/xPj�{��A�o����u�K�����C��H�B�N'~�`T}���q0;��G�T	��ip*��ȡ���Dz�R;�>�Ba��ȡ��-X&��^��W�����ѵv$���Ý���Si����QJ֝ ӎk�3��0nȰ?�4��?�t��1�u%��o
m8�jQ�~���!Ŗ�V�!��A\K�����i'����~ N C;�^q�X�l����R_D��^]f�(�bS���r0�
q1��2���s^s��)[^9���=�׭6�Q{Ѭ�����j�exY���;�P ��H��O}�h����f~�7���J��Cxgի��6.�^�q�z�X7��i�}f-N�����5c{��%�.�f4E;i�yΉ����N�9���CMO�3�jd�L9��e!���s\����ޥyҲB�n�f��c80�Dk�yYD�N$W��֯��Pa�1��dU&�%!.QH�O"�4�[���&U��ۥ�V�?R�%5�)#�[һ�+�d�%���z�8YĻx�AC������`۬C�=W���F�5�F�S�����y���VƄM��O��$��nq���"r����4��@'�-fL,����8�ne0n94���|�/ƽ| M�b��|v1���d�E���L�ͺN��������lӢJ�nYݣ T��/�3M;��$�Rvu0�4F����)2�b	'�٪�(���Y���J��ru�������Y�z�]�M��=��q9_���3�Q��ӻ�"���!�as�x�2I��`7}���8���n��=[���ldT�+p��r�Y�لD�����"FT�z˻�I�n�ۨ�[c �I>�M�x��o�s��r4.G�L�����0z�OF��O�f	fڇe�Lv���N.��TRۃ���?�8_#\B8�Ɩ��ˉR��q����Qi�yD�5[[�[� V��W��[�թQ%|��`CU�.�є��g����@ƹ�L���GV��t��o2�eg�%���$4v\�
Y�ɴ*�c�F���\�:���x�<�7��S���P�C�Y��3P��iOL����g���ɬȈ��u����!�l�~QI�0���8���)�zvu>?��z�zjY�<��	4ڋa/�B�y��|*��A�;E�XHǰ��	..�%�R� �@�6�Ho������(n��7�C���*2)���֝g�QQ��)�Xoh��{��X�9�q��u��D�4H�&�"�K�Kb^p>���U� ��L�1������D*�ηb�����K�m�~[�U�DV��n�{nS�mc`�	�!�;�^rc�~�8|�%����7�~L@��.�/�~1����Y9�ȁ�2̼��d�9S,�n�x���2e��������r�AI��k��?��\���k����x��eZ����L���W���B�5x��l�쎥l���!��K>A0{��KW>Z�X��yn�
���r��^�5V�^��~L�W͸�hV�$��?��x`��ߛ@v���@��W 0y`�e8�q"q����F���H>E�����cE��J��E��-�q������Ue��6׮^��ޙ��^nW���g�Hb��j��$ϞSC#vun����xE2��Ч#���^6ơ4.x�Ģ�%K0?-��.[ǿyy��ܼ���w
<;��W�edl8��y��G������Y����Ʉe�9�MF"��X���v.�0��(�қg����!�*'vM7_U���X��@���,H�w�>?��׬��:�e�T���#���- x����U)�2)����DtՊ�ԥBڍ�Ŭ�=Q��|r1�g�wz�[#%"�X\l��E��Y���S��y��s�L����h���pc;'����d�9�aBGt5���K{�����e�9HƝx��;#�֐���,�ݓ�Yы��Z��k��Ӄ�ƛ+�`�����۝v�P��}�˔�~�yڿ1�ݟ%P���q_��B�>��(��*؉�*GK(�z��!������}_�����A�&s^�f�E[��.X�(k�핎&T�e��ګjʟ�[���p�i6���to��#"X?�-��8%^Bu֙U\�A��1.��YƌD������#Dbqa�#٫RR��ŭ�����[s�8|�*��k�Ma��;�Q�/��@�	���$��Z�:�wra-#c�!c�Kba5��he���QߣkfrRO��Y��~.���������]�D�Q��G$<���>4��/��>}w���ƫH�z��+��7���?��x��E���@�W&2+��Z73�m�J�uM�Œ�*�����S�~��׮���~��O��MP���->��ׄ��~��Z�bϷ'PM`�.�ۻ����9d��D㩚9�y���*w���R'�X��0TMJ�3�)&�� ����n��_T��%d�E&��(su.��L����������ܨZ~������m��?4�Y�j��1��#����tq�}v�5�op�AR2������2H��	�[$O��T�Ə�"q@���`� ��2�Q*qI�@��"��E_�|R�) �B�e.=��7q��cg�Bˮ�ʮ-T�V����,�C1S��U�� Z_�k�pp�g,vF��$�&�d�׆ ���cgTp���raz���eޑq.T�K��}�LY���$���cT,���U�И�W����&Ӳ"�}�"F��&�0�c�Y�L�q9Ѷ��#T�_����4���-nU��w8;Ty�qq��ß�����u�����k�&��#�fA�ְA~{�m��_��ͻ<kI�{ƾ���ə�d]��܉Yg1���-,�M�x2���.��ps?�����z�(�r8̈́�^Lf�0=f,�y~��\ۢ,�����R-��7g���L�f��ve�cty���!�Q��� �)�D�.��ȧ%g�6Gs=�"!���e��d'��o���L��>�R�[�u�Q�x�g}^��\+m��ժ)��P��Xnu�R��^���
�
O1�X��Þjs����{j㯛���YQM��$㈼���L`�~%�r��O8�\���l�"u:�K� 0c� ?���R��|�	�_Lfӌ tz�0o;��n�
�l(�v�IA0�hD�����a�E5�IO��bR`"d!�,�����S�����⠀W;N~Yj�����V�\�6̓<b�5"��H~�LRJ������ltn�ˍ+䃩S���صL8��^&��q������Mb��`�X`�{��v?�7Q��(r �<C)D�e\���N�
�a��I�.C�H!&X��N�nrn�v�ś��vPzv����ⅆ޴���B�rQ�Fe1R�i�gT]��W��Ⱀ�y�Q����Nۈ��p�%N���[�H5#:��� ��G���)�Ҳ,�,��c�k�Hl*`�u� ���GU]�6��e����N�Xqp˄N��îӄ2K�rVN#`��I�ro��x�X��JXV�HU���׿��s���\4O���J߹ES	�w�|�;c@P����    ���sHF�����ۙ��i��r$�Ѣ�c���^Q�â2��.���Zr�����
�Qғ��m3L�M��f�0S Q��(�\S/`�M����뀔��2�(��A�7p������s�F�l�oͻ����,�����?�e�.l_1k�5��/���X'����hǮWg�����1Q)"��]��� �F15��b&��̋_d��b6�.%@ PC#Ef��^�������2���xy�B�[_��Wx͏����P��~� U�&q�[��m��uz%�\�w[8�����=��'w��Z�H�i���y������Q�W �J�
=��س5sH�G�e$y�S,�*��i�٘c��mG��_^X1Bwہ�ie�0PdJ1)�aVyJ2��������i�^������mc��M��������9����g����ݏM6�=�؆b�V��>�a�<��;tĒ���FB�,L��q6Y�30�>��h�Z3�g(�����@�e�Toq@O�}� �9ѯ���b���2����x1��]����4�ϟ�J�#�~%Q��!�ytr:t���Dk���^�:c����&O�|�&�ӧ����	�#��t}�B�+���(�i�d�;���(�:��y�Y?��I���,�W�t��ُ�K��Ӛ�ʷ��w����Tj��|�ϋ�,idM5뚪�Km�9��>�`Z�q���9m+�����Eq d����?��z�xDp:�
�&;��.��"XI�n�W�_��		XT'�p���h)M�|g��9Q���6�b�ݏ&�#�M�sl��������(�10�T;A���}V@�|�;����!�������w�+r���i�O2��S=�|З�g����Zo�7o��1��Qx#8�;HĿEv)��F��a�hF'nɷ������'貒���[�5J�S�=������CǊ����"Pt�������h��:���:Ybo3O.����2�f���#Fټ��S�#��P��0%���r�lV�{�%د�e	�l���2G�ھ
��ɗ���ĉv��R-�s�A�#���@�3S��M��i���k�����2�|�6�6صz��ύ���x���O9uʝ\��+�q��:��%��ț��_�'9��&�^�
5@w��;'S�i��x^����p5���Ҫ��ht��g@����'�7�
Ҝ$�B��w3�SР��22��|vV�/B�ڏ�]c5�Rj�ˮ�����gRZڒ���2�g��[8��_7�z�N�s�%�Fa뿔н�tд���=�)�&h՝�����u��]��[ޯ7�ru��3���t bW������*Įak4Cm�II�7[��z1C��SU��t���苇�O�p�?B��[���m`���ڸ����ټ�.�H����oi�Ƌ�wG�Aq6��;ME
YK:Mo
m�z80i�0�n��`��a��[�o �q!`���b�
�]�ai.5��<�sc��h+�R�.q:��2��~����o<˜�ܜ��]��e�~�0I�G#o�ӛ�D��p���Ե%�GX0B"�eỈ���[q�	$�h���n�M�H�͡�=��0���(��Pw�EN=�+cǷqJ������M�N�)ӊ7��ז��w���>R�OH"�e�ţǒJG�yv}*��=��Y`*$��Ɲ�b�8�M����&��԰���q(8���R�ѣzvfp �!'�U�/;fq���|Zm"����I��A���x���1$�;Γ��4��{R���`��ƛ��^G<_לԱ��AucLK2��l尠E��:���d���Ƴ��6�F�����P�B�r�g"]L��h��/���k>�Gӫ����O�CJig_�N~e�I8��X
�V�>�G�U�vK�IRL�5.���A�=#��R0�7�&��2���9���l@5O��7e^�'��pV6�����x�l��q����լY5�~�7��D_ȿ����P>c1�=��3 ��-��m�/2E���L��z�F��Z[T�7����B^��M̅-[`Vy��&N��� �y?�@]���q�O3��.����*�F�#!�i�7c 4�.٥�&���v��I�D�%=�j7l�=�������w_S<0�_�/*O���X5���>td?�`@~�r"�r��k�Sl���B{b\��r�&��d��7��u��7j<Bom|�R��u�I;>�|�5�?B�������yv�NX[�Ѹ��N7#���pĵp�u����D��'���v����N�ɸw�84-��_�h�.q�y�,��i�9�^GwC>j�e���%|�q����݂R�#�(��/K����˖aw
c
Gl��b�0iv`��\�O��W�K��� ���Lr���*c�
��� ��q6@����~u<��H=o��^\Rg��J���BFEe� o��9(�$��"��� �Z��㵧Ŧq��nal��h~�t>㋄`�`$%��T�h(oѝ���u�����ժ>�Q� ������פ@��+�%���M��'�M
�L��[��7PG#
���w�"/�G����i)*��0C�P�X�p7�������l �yŜ ,e��*��)z��Gr{Czv���(�]?K����!Ro�*[�y'�n��uK|����S��r�^������f��5��Meb��0��X�#TǢ��h g�oK���w;q6���j'��|ҽ6_Ėpb�D�Rn@9 ��/���m0-s@n�S1���S��H{K��Tz�<�z~�Z�D��:w~c�ft]k�Q����7(դC����)D�bsa�-���!N�8M9��"+��d{Z ɓ�wc>X�8)ė��w��������nq�L�\!G�ԟP=�n5�Yh6,�S_�$�pҦf8[F,���~>�碗��"τ\L�8�ؚ�pH�Q��l�,��Ks�'��<%'u<8T`�R�o�����*����2Q`]�`�L u��e���W�
��U�uke`�/�����陀�t�R����!�>��'� �.{?(�G�ܘ?����z��B��� fXnڎ�xh�Z��+-�+���;Z�$�b�T����Kޤ��6�*;���n�1S9�aHg�ұl���2�&��t� $�q�d�ycڳީ�UtEF�ؤ�4�qf������8����� ���@�VRFt$��b8.'���������9&]� �0P�vX��>������LL/�� #BJ^�16�(4��F� г7w�=F�	N 0`��Ǽoe|)���V���q��U�^����π�G���ɴ�Ɖ"�[TxLcs�j&h�5�I��g�.S�(H ��Ǯ�T?w�v��
��}%�@� ��MʃĴc�X�|�h��T�A���ͮ�Aqr��x�䲔����Cn ��
�+y㛋p
�P��YuC���%L�޳2�	�q/���I9��]!3�aF�������h�%�	�bb�ߖ�;�|"N$��"� �t�x�*����D	r򑌼���^���^o�7�Y��t�N�Tp�@{�����	��j�d��y��i��Xnu^X92��׋����L�|�:��&��zW���nb�[�
[��up�8)��jq���~�o�?�����?��\�/̊h����;O7@d�{�{�kPK�p�e���p�ϛDm��MX���㶄� ��y�,�F���ڸt��`�UV3�(�{[է����s#����^�4m�����.!�Z�M`o�V��a�:�վ���i�U[#�����z3��_�����A9�eB��b�Q��c���������|ό�^Z�!�̚LOޅ˗Lz����@�}�O����+٢R	�����|sxqU)}j��Oj����G�{�x�@�����A[����&d�M�J�U� ��/���o�NyqW��r��Z;����ߞ;S�p悒I�I	�Nՠ��1� ;u�~oRc�.�Uc����-@�5�}��ԑYC������k��F�gP���6�q����a���цP���/k�����X7�8���'A3h��S?~��W���Jf{gc�}�g�Y�Y��sP6o    �_�v�:J����'5g����I���N��ߚeC�Y�$�et�#��^@·��~[U��I��F���������Ty`z+���!����_�-���S�c7oV�^B��._
`�ρ�0(#7���v`�L<s::�!"����C��&���_�m4̈́�]L�IFT)�d��5�����M��(��nZ��hH����v�	�+�,���&X@��ep�S�(��O��DGa�*��1���<��q9g"˼w�9s�3�t��>��e_J@�S+%$���-wB�H7����3����������;Y�iR����������z�zu�"�e��5'4&��_ș~>�{sS���^������Oa�(J�D�%I2G{/	j�S���c�[�+RU]?Tm���{�V�����Y#2s�wzѴ[ЏF�?� ��/*������t�,�v<M��Rw�ʇ��N���@4 :���kt�P��uu��H������*5í���tQ�b��[\mw$�8�<�M��L't��É������e�*АE"���n�f�4�l%h|R����wߺ��P��*M�\����ן�G���r��`}�,&�Q�_S'���ͨ�:�|3ީ��,��:"?�J�ϞK���ʅ#����H^Gx-�X�HA�7�bM�շ~�޿Fw�O��������NVaձ���e����M�;-�Y_�p*����m��������e� �pyi�3��� ��<�%�u��	#�����j��=�4��F������3��ءKg��_Lz����� ��i1������ɰ��	���'L���Q,	���6���Zt��#H����~���!ƪxԻ�}#��C1�,�8b ϼ�J�G&p�-R�	E�5�-O؁�ieE,�d֜{Z�JH�5�X�kO�n*��;)8��=�y1 ��r��0��b:�3�ȝ�*sy��r������i)���$ ��Й_� �:�ĳ���:��o�|�?�.EO�ч��b�JfjC4E�e�]���g�(���v9�2�e��w�|_���s��I�u�R-UhR�g:\��BMF�����u�l(��S��}�с�m2e��/���\�_�qKw�$��n�#ч�s� Q�4��r�)�.�5�w5G�����c�S�EDC8*�T$jƳ��^�#�4�@C��#��5g��ƛ�@O)��%_�0f]�7y���}y���_��d�T�CLz�?mj�t:�d��8��q�f��:�e�ov�r4R������Q� ��FL'�9�NU �<XEQ���t�v�=ȚeLU5Y��Q?��Š�OJQ��0xU"�F�xUIq[���y�<���dO�1�a�L;��,���*����P�3�a���n��@�[^��*"�jRY�͎%j��\J[a>w�X�s�����hb{��Lj�HF�<��	0o~�t�s�u���/춸:4�S��|��?��T�\���O���B��5������&?6>�D��is
XH?�h��sZɖ�@��4K��d�Ξ�Ş	Ҟ$����Q�j���苼��^^��i9�/Z���-����n|�+���L���2x]����L���U��.��]�=�稁�f.k� $�X�DwW���ɦ?*!1��e~�|^Òpm#�B'�e��Au�2�����t��j�`���C��A}�Cn�}�7��5u��U]�82�qq���/ǟ��f�k��I��(��M�fj�k/{��2v�0�˪��N�!�6&�5p������"?��Y�N����5zGq����*��6.��^I����yp��]$M�s��Z��Ɖ<"���OGi2؍
��&˥	�ɱ��t*����"}9��zb����4D]e��(L��1U����=1.�aYL3��.��AF�uu����b��i�_�	V�����Lb�*� ��ƌY�$����#toY��m�#����D�������#��=���X�Nx!��ߙc�
�}�aT��?���wG�d����Su?���лδ*�o]6��ҥ�c=�`I���𩷡��B1}��v�	��kR霛�_�!},��,6U�,��^5�����cŬ!���~0�[�>�Q��v4��L���W�����4�x��X���Z2��`����:��'W2�A�S*��B�CC���^˅ ��wO�u�k���^ڿ,�_�4|��}�Fi��z��o�[���j~i�Vgգ*��E��K>�u&�3A���p��|��P�Oɯ�����
ē�� $Y�� pbM��E���K��̲���� Z`���`�y�����2M|2�-~�� �&�l-}q8�J�]��ӟ��kI���v��]�����eu�L?��A6�mC*������7�����ϟ����B,g��KE@W�Dt�!~��V|�6�=k���;�U�2�q|�}��8d�KA�fm���2�1"%�N�^n�ygKm���J�5�ĥu�a��5�����w��r��\��O���O2�17`��#ߪlN^���~kx<p�ʇ�{�s��1�N����ѭ���Ą�ߢ��d�wλC��X	'��PM2/��`�?��J�4f�*���Y���|Z�"��b:�2Bo"�7���&��:�7�y�T��*�:�la�����b��j�,��N��;�_,�:�V���^��+uɌ�
t���"�=*�6SĹ.X+���8��8�l`�TCc_��Q$�:H�xa�W�y7�@��n��ߛ��z4��<�J���G�z����7q��(�C	P��-��{�i�	y z$��̧�E|�SK�.�ښ?��`�mu���R��t��?�@a2�h���$$�SN7B�4�3��QkCm$n�0f�n@N���;�Ֆ�����Н����C�Ǔ2p�+��4���Ch��D9��?��	�Q��_uX���` PG�K���
�˵���:�{���J1̈́��[d!Ά���1K���Ե
��*�Z�u1��k[X��}�lrh[����h�b��I��=^n�JX�v�~�:W���?�EcEž?�������F��z����`���V�zT�>���^٨�!�VN_�{���`�hb�<\)�y_�_�9w���W\'H�+����y����Z]�B�W-��4qDs���6�`�"�:OotQ'�{��m�z��lu��^�ڟ�����eh�~n������b1���o�޹��x����~RHt���lB�sO#&��ˮ�;pVW&-/�PcYT0����4�-��K�Ň���q�l+���/+$��R�;�e�	>��}�m	���I���׺<cn+��5�|��[-�����������+ u�����@٫r�����9P>�EOL�QQ�����t0~%���e��pb�;9mq|E�kKg���*W��e$�����*C����P�"��}~���z2:,�t�H�xa�bn��ʀ�1ʵ�V�E�V�:�x�|Kzn���"��<;��U���9�L�K�H4�A�z��'?�'������)�%�E���h ��\&��̪��]��� V�}=l����ļ8�
ۄ��ns��zR���Ÿ'��`\�L�Ц�z~�)��Vp�Vdܤ-4���''�9Q+4�=�x�-��x�$Q�[�v�2�	�G���:b�]�%��r��rY�%ڻ�'CǛ6 ,�#B����,�}uW�k7�E��J�@|a��~��-y9EV���4��Һ�C��N:���B�  ��xo\V A�S
�����{���@U�h�e�Pa�Q�J=(A=6鳌���u?�T��KT�b�è0*�kVW#�EQ&e>Ыk�����-<��NQ: ����Ď��ͯ�Tp��9/>��~�_
���B<g�%sa(�����X�Z����^:�>�
�4��(�Q9�d������味_2�g'N��J��G�J��.w��²A�x���M�l
d*U&����7+I1*������/m�������q�R�ċ�9�/���yh��* O?;$�l    E,�W�Q� x�Yz��X��U�M���z���x'��pʨ�>�d�-�E���K����lJ�����h�rN�AE������[3_�B��:5���}1����3Y�eM?�Ȁ��M��صY˼�ܓ�D�m��Vl�s;v��Z�P!sT�
#�go�D�Wp��t�!V8�!���b+U3�N���sA.M�R}�=(���R���ڋ5�V���6Xo�z}�瞧��j��Z&ۛ�Z���T&$��X��#q�ɑ�N����|��E��u�-�u�ٮ�����G}#4��ޗ�	s(�Lr��WMX���$ZY2����֙
˟*�Y_^��x8����#"�~��E�s �d̓)a���R��|u�V�	�L��h�U���#a ��-pt�D"�r:|�v���g�iI�h�8r�=� �hE�UT2~x�(l&�3�1.m�Gy����i�{�( ��~cDz�l�B˕�V�@�1�=)X�!�6�$��4'6�{<��e�F]*PN��rr_("�)Ƀ� ޲�n&?�Ž+�0�՗�$�ߔ�9;��i<�pZ�4YMA4����*�&�|��T?*xW�崡)k͔�l���p���P~�ˁ,pX���-� *J�����q������d��ERo+��Ϝ\��}Z��1���&>���qۑ�qg]/���G����h�{�f�ZloxT���,��/k��[=��h��g�y�g}|��n�R0�0�N^@J�b�4`�����'��ł�et�������<.俙�g��(#Î��p��,���(q��Jo���;c��'_�P��?z���"hGTqA����qJ�IW\��ҕ�k�,�3�G�0�j��b%�q@6.�5$�����M[�L˵B�զ=p��A���R��i0/���ol56 �^��oоwu�^��5lm4%&p�f�}|�7�K�Ġ��q��o|_�<,4�V�9��dU��$�U�R��S�d�>晥j�zf�.�C
502�c������D��S}�P��W�=��y&�.��!��:Dl�i|��e��a&�;�tk|;+ku�dZ���su�A=W)K&�f.�]ͥ]&v�V���ƌH<{+������e1+��Ϧ��
��t�d�+J4�m��r�Ą�Q�dg?���[yYŧT���k��k�o�Y��> .�J�/��+!N����e�ǋg�/���i[�]�/��W�ʓ;���R�#���h���Χ���i����|��t@5���+����Pn���$�Ǘe�{:�n��&��a�"���jۡ��P�,2*�l����nnEr;ɧ�О1̧��(����.f�	���d�M�Trr՚��2�idR{��;+?N��]���q�In���ml���P;�#���P��"%ʇvϩ��E�t� �yDXD��)Y���YgA�&
�xêT���p:ޘ��~j8GO`��O�!�=ё�5��1�ȶ3�)�mu�����b5�[~���y���~%�G�ݾ��*x������O��Ήt�|��H� H��	է�@bz[Ϭϥ%���;����|!�W{����;���i�l�Jʣn_��Q�u���֕��u�P�z�ϧ�b K�a9�3!���4s$5e�~��Y�ϟ�{y���5+Q��8�Q ���'��y*8�)�=�],�QQ�5�iߜ��y�Oh"�<�g�}��<�0r� �+��P�ٳ�]�-`?Ld�Mƃ�׶��.,&U��=��rq6�*�=E?/z� ��h��|z1����1�h�o�j�@(��.�vV�[;�m���r����_���9����i�p�d;����@9!l�%�gw�^�r������lW;��?�)2��Ǯ���-�����7�oY\u=��+�����?�{������G�O̭��~}����?�����/�7���`��X0��MZ̾N�%K{�������fu�$���1�wƨ�'%� ~zd �=�d�*�0�E�!y�J1Ȅ���uR���_�a�\�ـ[ʞ��?�|B�Sj�k���/rY~�����X.�\.�i�]���?����� ���/=1+EQ�Cyg�������؟�ɳ���pp��G8n!H�
А�D�~1뉼c5\ML/��<��.�}��k���/��P�%��G���zH/Z<˵5�N�����p?�䑈 �����/dO8�-�xɎ{�P�aP�]���Q���~�:Ү�4m����'��1
��iʩ�|�~�J^�L+�����h(%0�t�{_�-Y <�-~|(��9k��(%0V;q��%�ren]����I�(��c�{g�48�WIxzuP�5�����! 4h,&�"/�I9�uKv$2ȃ��۫��N~aY�W��f�{X7[�iޫ��'��z��{�p���������7�~�����/k�U�E�g��:���U�8	HWx�m9����c�9i�
Z��h�-��_%�R �D�_�3��f�R�s��\�(<i��n����z���:�/t�v3�B��_U@��
^V]l)]]@1e�j c����n3,�������:�������S��6.��^�Ԅ�$4!�tFu�aL�+f�����!g&���AH\�K����T�pK�Y��M��vpة�,���$�p.�x)0ё:`��Ҍ�ex��9�Cי��r��k����λ1�d�[��d�<�_O�y'���T]C��!+^�.��uA��h\�\��G���۲u.�w��a�s6�5���_͚S�dE�=G����P�@ԣ�G�||�TN�����ϔ��I��a��0��5�(�=��	p!�AO�Ѱ�L�#(*�#��Q��Iz��mژgY���p9�.$2�����n��X�\�Uz���J�`���C�C�e�;�U霜�m�FT!��\�IA�ձBf����Ql8�7δ�e��֐��")�5-� ��G�9�	���4-C��4�V�p�$v	��`��b|۪��үv�Q����mg�=V�R��q�鋐�c�:��o��z����u�T]�x`����V��ժ9�ΆT��b��=�
�X�eDY�M��x�rmd<j+�)+�B��1��2+ە|x13���6�l�#�<>F�"����1�T�l��0c�;����M��=?$x��=�e�3;�ղ��3ە<��~�$�b2�XTs.Òi��V�Pf���'�e1.S=-z4��0��������L,;FI�F>u��wP�}[;��҈6� ���HϺ��1CD_�Ԍ{r�h�8t�L��+%V��2�K���w��ȆG�B*+J�3��XL�d{�� '��T��!A��f�M5D�t���7��:"�[��o ��ٳ�ד��n��L��nqʃE�(��b�T�U��<��5Y6����s��ף/`o�����q��
L\&,C�D�M�PB!^ ���c۬����p�dڐ������8*��ݠL> J<9nY��0��.I�2�(Z8�[�b
���(�i&�����Y���[�G�<=�'��6��ک��8���V�~UՌ�\���3�Ȏ����lz �zz�ۗ�@M��:ty������,����i#c��� G�3?�-��C�B�xU�X*�X��㾉<k6�wO*�Bx�,�W����ۗj{�nGz�ʭ���5��������j�_�
��VI��
2�#q��?G3x��[z��t>�����)5^R��朒;!c�Ey-�֝y�G����F�`Et��SP,E�E�V�����po7QO���3/��v�:AQ-�#��V]º�rR�먨s��	.�R�qۇ5�^uCV���e8W��zh��,p����qù�gQ%�G���s#I�Jd��T�T��f����j�׍bݭ^Hq�}h��t-�m�m~�Tݭe8B����{�mw���w�e����M�;��?��w[ 	�����l��	$E��/��A��أ����ЩP�ſ�h�ĵ�EZ�8N��$�sÅQc%]M����M����Dc=�(�j��c˒s`���bfU�A9    ��$#����i�����4��^8�i|U�}&�yJ,5�NGw�ⵞ#V@�ʧ!sLVUr��@�kV���;Y��Q�Gh!���-���َ�j��^��Qz���A��M�H�O܃7�Ԁ���vm� ��p���+��|`�il�&N�V2�P�E�j��Zu�2���zwZ�ef�Qn��K���.7Ǉ�@{w��	�ب/�z��-C�7���?��x��r�M�;�CD_���k͏|X�!n�XbxC�X�~r�n��gv��1�z�5�K��A��!{�3�a��XOIc	Lw���~�`�����kq1�2�M��X�i}��#������;^��ZC{Q���A��qD�B�q�3f��pr��h����"]G�r/,�	�u��5����h����d�F��G��J�O��'��[�)*��f���
TQ����ze�<������ś�_���|�%K�]�$�K`����]���w����J�1���1;tr�9x�C������"�	Q�Rd�*.��<�E���"Q� �9��z5���vpB{����|�&~��bi&R���Nx<;���9��)�RϛuK,+E�����r&R\�ka��v��X�ǴF���N=� d��\��OvEM��p5�b���ϳ]ONZ�@����U�B�A�q�l�y7�;�p��jlz#��IknJ7W��j^oU3ad�Ipmi	�`����M�S�� Yz
әD�ˇe���X���"C�ψ	:YDv%�L��1��r�O]?R
���
��t��);�H��|�8�(�1�a3��\E�������8�t�v����#�Ԅ��k��>��`EпY� �^��ޙ�N���}�ɦR�' Kv�d.|�.$�ni`Ƀ���_*���꠆{2N?����#c��W�/��[��B%����� w���Gzc��0xyX�'�f(��V: ��[1;5��
�K}���	�>2�t^-ᴜ�m�zm񅶯����̈��wEK(�6H��;�(ǔ�AJ5���P.9�*�E��n�?���$s�N�"^�&��[�j����)�\�6X�$�2�cg*�'I^�w8s�$�H�� Ԭ����Q�V~�r񬟂��"{��ʍ��@ߝ�߱S>TM,���#���8��wqV�@���{bZ��0S��E�l�!ys46�m�Y����ّT� ��~���atx~�Hd����k�ţ��'��V�Q�M��{���������A�w�wF�������zw����7��y`Q���2���[���*2���wj�bľuR����U�e����0��,Pp�s�|��S���!x��bZ'dc�6Gؑ�郩my����ri?~Y�T]�ޭ�9�D���~�@Ђ\�W��?nw_���Cݳ��ٳ
��cv�	�\�y�$�V�e}N�����h�5'�"��ZZ֋��2O�(�w�ܓ�e97.��]�j壻`�Z�,(c
��&��N��b�!�O�
ۆ��.V>�'����N����d�Ua\+�5-pLy`���*��6I�I�����������n}%__�'~����Wq`�}�ƽ�2���y��>P�5JU�|.w[� h�N�d	 o�����ZIq�m|^=j&�� ժ�+*��V*���D�5B�b���˿��H~II$3	n9;{���ڶ?N[|mFM-%/Gy��2�M��j9�'�I�>�o�5u����{��(��E����j(��z���d�4�	�˾�e �F�P�]j���{2��$L��8�<<�ɕ�n�\�CN���>�fHz$Z�3�Ԋ�I��H��{yJ��eA�EZ�i��vK��o�����h��œ)�1��ky����W��8cՏy<����:�C�e����8.��8M�  ��B�p��-�+�8Ko�j�����^>��>�a&��b:fHNHF�f`g���Q.}B'>a�IU5�T,�+"��<9�!�j؂�a��a�N��u(��ʻ�u�@L�u��8b\�:3��V|Wd��W����<h������vq�`(��_����Á���d��8���K_i[�%@t��U.|�A	P��M	����%^�\�8p�G�)"��s2-1u���±�;Ni�K�t>��h����l%�0��Ǚ<<Ȏ��z�[�:��]�\��qH+yh���*�M�p�.���X!	�[nI���iAq*^�s��o���p�~����-����j��FB:м����ȡ!��xRP��P�)���i����0�f��G�|D�ѴS3�f���k��ɜJuvق��j�L	f��`y�XL�6r��x���	���<0����v�2)/��)�	ft7�O]qLc�1(O�uĠ/��b���#��ˤz�9����}|H��Z4x����,p����dݰĺIc���� nэ��b����̡:��(_�k���փ&I�<`"?[8�d#�[P��&{��Ze���[���cBE�Lf��0(�Z���W���^Ԋg���S�⑭d.��Re��0�M\�^�s�H���q��T���^>-e�_�3�C�l�y�Ao��y�h���%��Q}���ȞXJ݂ܱ=\��މc���"ٱ�<oC9���%��XHw�5Uګ�C�*#��@C*�:Dd�3Ô��*���rP\Ek�'�@0~E�p���[�Y8&�)��^��<vtrd&{SOV���Nags�C&�X�T�O>�Q{)�@O�H�jRw�#����b[	�pd�t������]��m�^���Y9�Ӌ�xZw�1���"R�~t��Q�A���G. ����B��a �����������lr��oN��,t��C�e����d&����QX!��;��Qh�=�)�)�D�mH�o4N�Ǆ���~N8O8m
��%w|ү�=�� %�KDj����Ě�O.�X֘�_�oh��m0.�Y��Ι%�ڿ���X����pgB�,���.���媄?꫃�ߔ����/����+=t�b
l]�ʝ�zNw���E4��E��iv�k�b
��G�W$�{��susT�]���p�|?y� n(UהosOS���1��m!#o�Cb���Bw)d�[k�� ���oT^�[�{� Q�#��v������֮^4��7��6G�Xh�7u�̔��2
eE���=���EO���y���~������n��޻�T�?����_(-h;����~>��E����L3Q\Lǳ��+���ؒ}fM3Oj�jTi����Jv{A���ξm�r�lUzn?,;Sc��Ԕx���
H���'�r �Q��<��Mg��n�;F:'<I��p39%
ǁR�R{L�Jᖖm3I+.�����5tހ/��g^�]C���>�*,"�a�C�g&ՃTvwʹ��������۲	5���cK�
��Ak���� �3�s�3;�A�~�%���%sc�������!\��mD�2�_^� r�������~�ߴ�s쭸EAV3��O|F$���脝?-yb/����<�x��e�H -(����z�Zd��+�cz�lFa�b	�v�)����ٸ���Ŭ'�r8Ql!.f�<�͚�fu�+�H���Aj�I;J��&� ��)<x�h�]Cn��튪@���ڻ`�ZF�ݤ�p�U���F'��M�+��f�o��V߮�*��$U��/�O�3�P�O\������&��%��x�Ӣ�5x��W�2��x�qA�$�	`e����k�0��$�f�l}���Q/�Ŭ,�?~x1���)j	�f1ڢ�-P���̎�mJ�c�w�pr�dN�D�7/rS��K��NM����F�ZaՌ9�s�U�T��nH;����&�3� zxδ�}U��<$��V�z�meP���5�Y��a�s�B>n����V-�e���L����q������n!�Qs4˥������U-��S����2y�5�)��&ls9��>ZGkKH4@#����l�5oi��ݳ��㞻�~��Z��*6�)���Cgj���;��h��|p1���0�ߥ��1ݙ"j�@�6Z��N�Ȓ���LL�
���X�*'ج�Mjc��    ��C�t���	��>�uc�qۇ��ꛬdto�������RP4g��{
��}j@��	G��ö���z��XI~�x"A�G�O$�D���oE�Sк��1�c�P��ɓ�i����5�DVv:l\�s�`�Mƍ�Բ�����4�
�|��5̷���%�uvix� I�r�u�\\n�'l��GqU�J����n�{6�ӗ�EP?�*"��i�aX� �
�IO��|X�� `p�y4���`۶'H�v���V��
��n���+�˺r
�cHJc�M�&�� =�б���ʢ�̾K�<�(6Ԝ*b�L;ϛ�ɰ)#�Z,S���L0t��a��J]���/�=Y��r0�D>���0C ٙ���D��2r�l����ة�+&0M�_��K��2����~)�B{��!b�A�-'8d�l�c�W&.�GKJ
bSݳ�oÎ����>W�����f��(�<fz�P!ǙLL7�:�B�4Ǟ�nLV�IoA��N�� >�ҭ�y�oTm,'}��[�|xIyX���
�;���]�q��(�h���_�bo6H6F��M��n�I�5<�M��=N�_�D�Ŗ��M��"he�3����>A*G�(��Ǝ˩��=I��Ͷ��`q��`wX]��y�/F0;P�ʼ0F����7�����	��3�#�;�R/��\�����rb!U�����;�Yg�16�N�$B$�%;`i������}�`ih`��''���&�p�$څT��d��'QrE�| d���q����`���4�3b�����*gy�����?�����lB.퍉��!�A��o��ϼC*^�u��K26��.�b��!�fʰ�z�O��5U�JD�Ǚȋ��l��2ް\w�7��a�*<y�b瞆4��;E�C��8������ZZx�ͨt��FNb�`Lc��d������ ��*�e��GEA1B7�I�|��B��+����ۯ�>jy�
"������T��}D���?ޭ���AFLV_݄��s-�����V��*&̾��֛酊:��>1`a@�:�ͅ\�$AN�$v��G|�*�����E�al~�N�_d�M�lR Qi�H#�7�Z�K��j�L�"��#ǦV��90���ܹ�[\mwU���=ؔV_P{�C��8�W^��k����H�7���w�q0��hC�mb)7[u��Z���V�[]ҝ<=�������g���r=d��l�{��mǓAOGg�zvk�H�%j�\7��b�*�����K%��(k�IOʡ��fBMR�ds��(o�N�΁K�"�:4��1b�/�Bp�w��jP�f�ڼ[v�DP��$׾!�*�_]�O`�0��+рYd.Rj��ɤ�5�לQs_X�{N�刅PP{�Ta�3en�Ò;����� ;�,ɉ{�*���T���+�%1��6Lu�P��1*Fp�;�M]���惞��\��,���$�Z|e�#�-�/�8k����H�4���?83<H��T��7��ޏ7S�LKF"�������8�>)G��Q&���7����O����+{f���F@���*�-��'C��I�v������P�w�O���^����ߊ���C�1=�$�]�"�ǌ�V�0������Ȥ8������P8��KC>]{�g��}� � �-j�W�{��3g�#@��K�� �|o8�栫���qtV�苢_�@�1�T?��N��\	.�H����E�QC_E��ʬ���|P��a��5 l�4��N�Mq6���^1�.aHn�9�]��R�gz�Aw���B��}<;��k>���h��|9وL�tz���T��OLt���J�@��W��:�h�H���u)m�wlZ��I%�+��is�����H�<*����z�"?r����f�e{����q��緊}���]������cC�e�f�:�z��Y��{�q�� U&���J�1(b_����қ֐
�)����UU��˽;��=t~�~>�)(j�EY�\5��3
��W�^�)�]=�|٥��B�:>��]��jD�*ͱ�N�",ʛ t���t�����n�xk��m�-�hz!,`�P��6�q=%�M���og�T�����'��9`G?c&���s��v����Vơ����^�4������	6��	��3߾�j��F�i��8������PH���:�Ch������Rw�z;�-���1}`��i�ՔLm���M*��+pl��N7��z�@�jU�o�~ڛ�L~k��C°xX\W�QOby������&���ރ<9؆�٩��~��D�<�L(�Q�ǘZL�|ɷa���M�T7�5{Y��Scӂ�'q\gf�4�<x���<��7�k2 �l��<� �,,ȓw6y�G�����_�J�À�]=�oOB?��?��eo���e�?�<��~l+'�
����Z0c`_mRg���h���n3L(J]wn)G��D�u�X鶈�8�8�c|�k���#�We�#��S����4�TZ�@h����R}�-�<5v�������V���U���%��	����[����LVj� 7:��r��i�e2�#�p���Ggf�B8WwH�?z.6���rC-�ҿ���U�y��[v-*u��z���ʫov&����>�=yS�G��M��h��H;��<]����f�#�2җx�[s����E	ꎹ��N�����6���ܷ��?�=�d ����@U.�O�����Ɛ�fhl�l~T��ŷۭ9@���6V�R'����@�1�F!���,���T�AO���L䣋�d��qʵ6Sy߰�I�u�@����u��aפN�r5���_�O(��^����ne�7-w���$�@����N� �mvʫ�4LR�ѷw��%�GĻ��R?��.yJ�
K���x�m�dzݨlHK�r�i�m"R��T��My-ת�V�&�Q>f��h�X�{P�F*�y̰I�J�CX��{*���o)S2����a���C�I�3Zұ��;���\����ТJ��h�T�1l�F�q�D���
��/����!�]['p} Ku�.۰��Ť��pT�`�Fq1�L��z
L���ˆ͌�[.bI'��i���0Mp"|)l[����Lio�Kq��6l���8O�*5A�	bh��'ʺ��N�K 1b��S�j�@RMnD
4罇6���0q*,���=�i���SHWϦ�2��N���Jn	'�q�P��R��̥dY��j�ն'�g��9�4<�z�x�%Yg�ʌ�
1%�QZ*��l��~W�ʢ^Wc�uh,��@6���M�}5 bD\�`1�W�G��9/�:Ѳ���X�%	�*�W�Y	H.6����ULRtD|��]�f�k?KUU�ORv����јy>��/&=!ʑ(�L�kO3J�'�U�P�$	k����;f#�(g~�ŶM�0���{�G�}�K��А<�xӭ�|STP�|^�a,������s>�uQ�P�yh{]���Ac����Q�_��3�`-���'ğw�paܹț�� uگ��K\�e��Q�}i���w��H�,�D��a�U�C(8MB�!�}=R���|V�����YF�r�Rᦳ��%s��!(ħQm�݂k�B�����|��r4-�Ӭ�i�a��/�jWY����3��b���?��_��I����L�/�a#�J>�Tb������͓���t �=�E�vб4'LB��A?��Ũ��</�@f鳋�l��i�&�hU$ոg�8�ь�%fK�t�v��|r�{�� <�x!c�Qy�l��)�XR����d�Y��_��k�-��y�۪�u�w>����1�2MV|�'[���5��&#��V��n�@��ޡ�yy=��ac�.�Gx�~��Gơ>?5��nh�`9C&I*�;�u2�H�m�ά��W�S�����< �{ɏ_6��:*5��"�r����^�0y 1<����X`��]���h�����o����kݮ�����z$�,Oi�2_+l	��
�&�� �V�H�<�r[���MK��x�A"$���$�б�%�}i�9�6��    ����<)��ݲQ�u&T�����ͽ���TwN�%kD&�7g�����l}iS��%#��}�.G��6�@�P䓋�TdDEǽ��g�`dQ�[|'������3��ѡL=�p8qw;2��	G�9�3�/<���͕?޵�?�u�������-��6�
	�S��(7�H'��#Ɲ�+�N>~^f��}Q��<���QYe>V����|�A��Of���U,��.PK�N((���,)h��:���}��Ɓ�l�kGX�Tٰ+�)��
d�HM+�t*���/|�ä<�RG:؞`~Zȓ�7(ռ�Dɉ���B�m�{�x�����-2����y�"Tϒ���x�?ж�/�1aL%�K�Jͮ�	/��d ��-��vfY���	�V��"��� gE���Ha�U* 5\r|�B>�q�k�,p�5��	^�#�aw��v��yT��Q?��H��Wj��Vy�����+�`Z�D&���t: ��s�����P���#βVꂂ�Yܭ��#}"ty��6⼙SǬ��zb�?	�#_�%�s*��Joxl�O_Kř/�i֧3f��֛>&�g����n�z:-�~�mRg{!q	��?3C�	N����a�زG�9 �Q��pt`S�E�eFy���H2}��â�>�K��@�E�d6Df?V]�C�UG�~� Y��r�k"Ͷ>#�u܇U,c��pS���(d����Zf�j����zԞQ�����z�0T͹P��/j��8����<8^̔9��(nP�Lp�f4)�Kw��+4"�����m���(N�&c����p��$��?R��^�C��{�uVl�W{q�J��b>6�h�d,�$��Z]����n]FVþ@�����*�(�Vd���pY��@�X�����IQ�?�� ��������1FL��8SX�N�d����wʄ��,��t�u��9�)��p�@��LK)e1+�0�0�5�(�){^z�����,��&�$w� 08WIK����qģq��B�k���j&8i�Eknw��5W4P��$C3�@�����+���S���ۡ��DE��,��,ݒ��F�X��Zw.��GV��-M�Œ1$ �v�5�O�~�\ީE�Ei�z�Cq�$ �@b|��;9@[d������Z{D=�ߣ=vY�6�j������l�-v<W�0gAfK��Sp�X"Ȳ�̾��6Q����ӡ֤���ȃ�rl��d���gԦqHɓ����_�dK�����@��}�p��v�Č��mI�����;J����`�9;3 s�AԎѠcc.5ΰ���^'�a.�8|DGU`��i.|m��;����'�o4ƶ(��P���za��W��f���7[}��W�O�W�z��2 U?�Q�W+���`�����#:�
�9c�;{ �(�龿]�?�+T �Sư�5)_���Q�.w�\�i�+�lH+��������+ k=C��xh|�7_%Ί����j׮����K<b	W��O�`���}���վ\�[�(���F�4�)���b��2zL���N'J)�[��ڌ�U��.��VD�$2��QI�׬-���H?�ǆ����;!s�j��ĽẚY�X(NdZ���ruK��tK{\�3-�J�{"&��?J��j+n��p1�F.���/򞘖��ƥm�UӁ����y���\�"�N��ީ�8��[�����x���	��&)hn�7�������'K�S�$@�`�f�,`B�?�_oq@q��TSǑ�`�(W����{o��ɇ�����T{�3��1x�ը�P[;Cn� 1���F�h�^�J|�0e��*|"�a�t�p�9�`�V�=MOrrR�:��5������p$k
jNV8>�ο;��O��l#�L-���,���"-�wr�}p7���B�4�/�%V<9��Vϰ=Vr�����#�-۾350+�T�q�S����L�lvr�/��	Ÿ��2���nv&D������HQ�'edsCpD�r4*��L���t:ˈ������RJZ�)��p��[�e$n��L,~�>|������K\۴��c���A�P�D!y�M��.!*�����(����s�~'�"�L���b��,���s-Z�󔅓��^>�US)
�72�3����F)9��]�[U���x5�(K��٤����QNc�����q�-`b��������{������fN��-$�����L̝�7.R�c�V���ɚ �m�=G�J �/%bL6"�\M޲�����r��	P%-l����XO�g'J�;��,�rPd�Y�A�m ��_��G�߫�\-y^<,�A;�i����&K�.#OM��M����;�t� ��D?���q/��iY3���*�����7�#���y	`H�����TXI�U����^��,2�H&�I�D�4h`�s����b�{����;��="?H�;����<#A�"�3�����{�2
L�E�#F���U��zO7d����ѫs)@�.g�`S����#p��O
��Ҁ;ja~�<G �D������J��~}��_�Vu�e�Ԝ�{8]�<�ݩ?4�Z�-�ҡ��h�[�����P�*R�5�F�ݾ���'�������~,�1�M����y��G�U�Fp<X�Y�g��D�?��[�%+���2�?�j��V��ʳ���v+�:NND�`,�T8Μ}�LD�oH:m�Kvɳ	'������^�bFhfD��& #�ॱUJ�M�����q��p'���P�i�h��8�D����3s-T�cP��ݒ�MD�әF5#��B3��A%Ǚ��2�x~�̊_�F��y�������z-��n�	q&٥�2N����쟵"��k�aC�(� l��O<ܞ����P�V�,b����c����6��u��agŊAf͐�W��&��m-�-����}(0�ٹi~.�㠮��ch�hF出u��a�ڼ;��w���u`�Qvg��hS�N�����fۗ6���3ՠ~��#ǀ��*h���\�� 7Ku�����<�W�Ys�������ju���d����
�yzo~5,hr��$�t���E��cF="|�c�6����z���]]��>����f������a7׺w3{�S�w�9��m�h��\�'=9��4ޫ��x��E&�~iSu)����y�G�8�B[8ǔ3�$W�OՍ
�ݤA�@������p7�x��EK�-}p���dJ�i��ܱ[l����@'��*q/&=��Tb�I9:�HC'���^d�,lRg=���	���$,o,k�S�
�c����gM596EK��Ae/q&TZgj�v���xqӺ~; ���b���'E%&UlFǪH�g��wF=�?��Zwgz�ΖYqG��Q���Dh|�Y¶�^Z�L2��% ����To�k� ]�����3��2��������p~0�s�5Q�C��*�B{�٘�smD[����-ɹբTC� H�a�Y��H�n�䘆=RR�	��_|fH�L��f��q.��ٜ�z]��p��M�L?����� �|�/Q���8|W;�h����1/d� �jŽ*�Ʊ���8��6�@;��i22�{�7���Y/L=�֏���̤R*��x����I��s������h�)�Ɯ?O��`�g ��a��Ӱ}�ƔVk��Wwz�6M������c�	����<�j=���i�rR��W+ 'r@8�x�K�'��י|旀S$�KA�(�>������5��~R S
�g��y�<���)���C��a��.�y�EL�m�`�X]�<'���w�=Ԁ�jK�c���Yr���lIM�4G�$�T�t�k�f>S�N��������t�$;�������uN|�@A���V~�ᮒ�A����K�C�I�����E�e���ɍQI�"�����#��K��m���nf4K0d��^!+�(2)Ak=��WlTC�%S6���J�R�r�z�zL�D]�Qf��g]��ALm��R�����b��q
��\���|�J���gS��(��xbMI�h���k���7�&=�� �8���b��i;MBv��zNG�A,    ���itSc2e"�x��[G씕�&�z��b&6(\��d4ldi���������I�x)�;�T~w����u�b�Vgқ��r��Az�ԉ��[� \>3�!<c�*/q�q���h�{��k�$�gv��1��=�*S���%�l��
2D�K܋n�j�j��@s4���'���?��Wb�-��_5�ʝ	_/�3
#��;74,��4m�m+��p~��O=�5�{?�K�]-̥��7�M*䡵ۣJ��|��w? g;��W�U��'ڥ��4� ܓPK k����f�u�I)e.������0]�M�$���O�`mL��_N�z��ds�6y<�`_+��M�UđB�^�-7u�D�U��yv?�lҕS��Cf�$:�p,8��$�q���p�Fx��Й̝�	���[#���7Έ̯���"�L#�2��V���<����xo뎹
E��;�=�*H�b`�?���Fz5�(���X�}��UM��_�d�\��������@�W���{�bm�#�!����4v�����cc���;�5�R'�f�{�͙��`QEX����wg%��!❮������(��L�0���$�)PK;�N�� ����d�N}��#U=(w�9/�Aڙ,1�Uh��錛G��E�ӧ�Y����1���Ӂ�nG��m��Iv�ۂ�*��(��eǏ;�s�5���zX`O��鱂����!����	8G&�*&�>�/�V��?4y\��F���r�~:��ڌ���[D1���C|�����������c��}��^E!�>m��DS	�7�u��͇����{��4�ҵ4�I|��*���P�n5��L%�"�M���5͝�Q��)�MLc|nڤaҸ��>�K�}Q�ѽU�t]3���f���0���������~EF1�7�SlDh�ʙ���ԺY.!5�"��ӝX�;|A&/u�߲Z���������`�w�7���oo���EG�[�<�7����XK������ӚR�#��jZ�%<��´R2;�9ƧW�f�aQ��M5�R��v�a6Tcr�S���9��3�Cѡ{ڛ1M�0�Oǽ�صhgp"�S�����>�?����E�4�S)�� +}����� �r���'�U1��L�g����T�
 T��K^�i�d?��RD�3�Ӛf�Fs/'�x�~,�t��h%O�R�(z��Կ�2�<����������iH��(���ur���q���(#����s!s1�a՟T����Pm�A��v��ڬl���n�z�7=(��pV%`�����"[��0���\X/~?Jp�4Wv�QI]iD54�e�>��|gZH��O�M���J��l��,{G�h�c�+����.�I�D�s5����e�9Z����#2����~��"��ۥ��Q�T���;��{l�눧C�Ca����,�(,�퍡�<k>��ۀ��W6h����R{�M�¦[cR$��'�S!.U,����onf���Pz�1�8 �t�ƑŊ#%#�d r6B��=��eMac��$�J#:)�f��5YBm,L9$���8����W�n4W���6��$�=ٕFt�H�]��
�I��P9�i�rR���6܍�%Sy��Ƌ�T}~�ƞ]�\|��@ߪsS���{�4����G��fA���P�e��@�-��b�σ�$���&5�7N  66j}�a��xP�z��"K�����覞�ww]�IX�9��i?�s�
��J*�F��o���m�uH�Mn�=K�;�]�4���r�MU��z���������,�E����x_���\�~�p�6'�����>W���N%U/9�C���C�ͺ�P����}r6"�ZW�|�m�R����}\<�(�v��4e��m�i��e���m��eR��&�(���/`���\�S_uP
�,m����>����1K�cR�RG���ޓ����d�)����,��:.�>�>\ $�;��'���@��u��+��_��
�gL����]B}R����'����@Y����`^X��zb\ɑvM�Pg��?4�z	ͥ�ù�人+�)��P�)�d':0c�e�rI�H҃QGS��@��J;�ELQm6��W�,�cH�I>o�����͟4TU8nA�9�6�4_G۵� �.�ᠲ�K��~��m:d�Y]�Cb���t�n�z C��<<�붗�v���}��i�s���������kg*n�e;.W��ڂ��ҋ7��էx��E��"/� n0���LJy6)&��L �b�����j$����uOs�u�M��˃��~�ai<�f󽎚V�z
 ��������)�ZH�v���+�3)�� �{�X3E��z���܍�@���o�F��ٛ;(9��!#�Ñ�=����yX��H�����?R�����C���8�z�W1�L��MJ�9ܸ�0�{ĺ�:��ҩc�m?�3�<yV����=��L�A�j�E2u�m��zk �a��R[�X��+$�tY,��,�!����(r��ё���:;�t��w�%�}}��}�ϡjs�Y��]�n��8��˶�| �B�tOI���2�[��l�!���sӛ�i���6жf�vy����:����A=��4x@O�Y�.��A����ݩ��T�9��w��n���S�``gx4���, ������x�3h7Ԧ���u�g�M;�G�p�vE�?�$�-ۓ��0R��+��Lm��9H:<���ٺ�������P�?�` �88��S}��o�]�Яj*7����Z�I�8���{��ד��S��P�nP+���@�(��,�~���lRʬ�˽���	�fLI���y�,�2	�F�m�`�#�M�C'��5`7��E��Ų�8��P)#�aD{D.&yч��U�A&{��Ȁ�P�@xS�����u5jE"�6-�J�i����H��C�+}��;�����MA	���bfn뇅:�U½Y�p�C�6"1�&a�?��Mp;���*�h���fbC����\C�ڻ�w������
5�B�m�fh��ղ;W�r��8�.n�Y*Z^�����̷<?t���L:�͗�9�/b��tN��/�l,x��2`=ȱ��SvJŧ�g��*[)�Ǝ�������H��;��ab`m#��_���HkuvU(���y��G>����z�3%Dg,U_��Kf/��f��]���>"�����
舦0Q�9g�qZ~�G��8��f��_��|y[��UD<����~�]6��l ��P�=ѯ�������IYft�=�@0#B4���h:({>ʢ�kg��&�Cޜ@��������ݷ9�$�
�
���tT��]X�+t���o������d|��8�|{�?�*f�|��U�fu%PY {�V۽%�)2��U��c޻L6cB{8�k��������m�tM�/�UO_��V����<:ߖ���4�v����(f^�Yڶ�	wotr5�$`߼%.���r(Æ����CЎc���H/F�u`?�ʮ�H���-��t���?��g[01܌��2D��?ͣ�z1�
Bs�/T)6�C�y�٦����Q�q��c�n��g��՗_~ެ������L�w,>7�O�����t�U��M��Z��ne��k��$�}���t�_5p�%��n������w�P\m�4���v�&�����
4&�j��:?7��˥�Z�.���x0�"�O@��y�� h�[�����.4���x�q��8���Â�K�yn�).Hl����@g"S���5�#�dn���n��Y��i��8s�p�O���AU��>p����"��^���!#fX���ӑ]j����8�uD��.c�hdvB�-G�`�~�	w՚���|~���'�A�U��x���_��ڸya�ܟUnbΟ����oRZI2�'���ZXИ]=�q�05Kj��$��X!���|�8�1���0_iB ��u�⼉�gi��j�N4LtA�H�����\���\�  &Y[�k�C�����l�T�Us��1�5�-{#�J��    tI}�A<7��E��A.�=ٯʢ��LJy6)���}gm�`,�����u,�+�M=S�E������h�uw+��JRh��^��+�n�0%������ic�U��o��n=��ԵzX�q{��b� :S�8���b]k�Y�ms�8M8�����ȥ쉁6����p�2<ޒ��R�`��Nd����q�����q�3ڃ�K�-&�:�9T��Rh�>�f�̨[�i?�]��:gѢ��!�v,��1��~�׫T�`D_n�L�b�nI�ߩ�O����(��&5���'6���R�Q]��X��t[�R��s�^���b�F��O�-���oyG�� M,3x���s��NbƤY,ōG�E�R&�NE]=8�A)������BC�j���SOƦ�kh��J"��8Oz�h���4���o�5�����2��[��>�?����U��<��y�E�
b������Q�(�����z��x�8�5�24'��GXڍ2���^�e�ֆ%���K���|j��*�����t����S�:�����	B���)k'nU������Ɍp���qa�i�C7=Vû�}�s�z`����D$0(�=�:���$�`��X���ְ:���#Pc�V�͊�{�k�S/U{d��=h@�x�CN�M�5�O=���C���'��v��d��"	CD_d�� ��qf�l$'�b1;}>-<d�Lv��H��Q^��;C1ʴ	�$���Jĩw6-�6�T��c�6 �2�-3�����\�-����7[�mM�Ua��:�2�M�X�色���b��M�"#ppx<I�A$/�D��i���]�:'ؕ��L���NJ�$0���XR@�*ƪDȤ�3Nf�ߦHq�"� ��ocH8.&<�q����/Nzg_n!��g�/���ׇ�.߽?W[����9~����|n��zoz?��N�������������>%��	xiI�f����N�r�����*�^i��i����Z��_�ocTJ?�3��I����9v�>�zQȅ�E6u�i�]/��Iz���Uӓ��W�m�|l�1K{?B�R���;�
>�7&7c�Ѭ3O��什x���_�+_�hN�J~D̖mlӡ�:�X��}�<�������3�Y����#�$�nU�J/<B�<y](ѠK-���~M�5I�]N4A��w:j[����82�\�a��VrT�2�@�)2���~�����'�5Lm�	B�F2���~LG@�6	h��ڀ5-돴r�)��=�.��^L�_g�I�Z�j[�!��o�~�&a�i%�zB3��DC�R������nf+�'3��Aww�gh�'�/QpS�TlS��{��xs3� �Ľؤ���a��(.�}=Zb�X� �:�'��QbGvRhŉ6>.m�L�����DQ��1�|r�#�sX�I`�2C���y�t����e&'��e|��m[7ݨeTLUPJ�V��)�tNc$���U?��`�Ը��!��m�"nEh�l�� �Ϭz�Y�����5�"\����� 9�'1��g8k�N�JE��o��R��
�Q�Cxe}4�K�o�.�F�vm�<y#����~��`���B��<7+��@U��N�/�����k��������!v��P�ox�_5��]��k��� cǡ��a���<���+�tQ-��,�-Df����R[�<U����A�>���~����Cr�����ɻ%����$��oY�����}�嗟7,���P�|��;������yE�%t#@b�/)g��CuD�S:(8�����g	�ޒ~C����:��O���͋�oU��X�U�m�o�])r1��  j�b���l��gD��Go,>�x��r�2,l�k?W�=9��� �b�V� �<��Vg��rϸ��֊?:�]�s;"Ǎ�BVX�����]Ö��LՉ�z�Υ���&���ھ�s'ۯdX�Vh�3��<����̺�[�%�1��(g�O*ɍk�Z�_�g����	|l�1�av�����~�k6�@ o�R9Sgp�f@�;ߦY��6��A��mQկ�5�%��)�ݢ;F1Y8x;�/�l��D!E21'"��4�����,�zb�[�2��M��픱[L+qN���3�J�
�̀�:�@v:��#�� u�}�"�'���]�#���i��J]S{�t�+�z� #���ƥ/*?X�b�r��_�ȯ��u��-���'rN���UI�+�(�d�(�\� �_�A%��3ʖP�A5b ��p$���;�F"�#�/��S@Sf�r~�<[�"b�ёG���Ǣ�Ҝ:�ή�~�z7�;ϱE�,�F�pD�x/wb8�bƤX�#)3R��B��y��!͇Jċ�g�1d�p�S��=|�6!ǈ}*��
n��4���L[̩!r�'����ER���2��*�[�d�j��5�ڽs��m\�3�i rbEW2�i�ݜ�����&�����sQ��eU���$�rt6�� +���w��`�v�+�A�}�[B���
�K�3�>
���s�¥���d�{��a�2#�${��5 ���O���ڛ�qZ��3�>�yTŞl���
w�x|��ߞ-i��P�<ΧwC	1���X�'����#���߈e��tZq��:_�TȔ�[�%���7| ���A�h��T�
GАF(֑�"ֈMf l�䒨��u���p�U��aD6q��y��|W���YhV�9�7�&Z:R��eyn0��V*�5KҎ3	�-�'l�h�f=%�zD�SG�9�@~��b���'��+&f��8#�Z������u&C�
Ω���@�[�	���s��V9*Fݖ��Ҁ�O3�TSi��ϔ3���d��1�������5�u��D:�d*�8G!{qu(.�*�[H�ۜ�x�/IQ,=��mO�h�"��q������n�:���U�I�׋г9��nQ,3�.	mО��k$v��G�{x�}��������~.�V)����EVȳI�Q�o����ɡy6�Y6r���b�Kg";#7�gV�(��,2��[�TK��	gEp:����}t�~�/~|<^�R���g�'6����P����v��^��^�JGe�@.Յ�����Z���"ͥ�,UN�q�zj�����^���~}}�W�zi�75Y�^?Z�])�c�T������k�
ng���e*m
:��zn�8��zT����3)&g��Ȉ�������)���jJ=�L�NǾ㖄H�1�cgt�gg���1�Ғ�#D&u P �$:Tt����{�z���7ju-ח���1X7�LnI��j����y��7�l	)q��zA��ƻ��X� R�|C���Ƅƙ2ʖ/F9V���H�:�4���+ r��ގ�6�d����ޔ	��	G7L���q3��}���8�&�-���ٺ.|g�2]G^�s���K��Ls-t����u��ZCgk�w���V_�6ևl�Gu�v��C6 R�Əi��B��3�\�Ȑ�
���-�y�b��l�u�B)���i�V��]�`����4�@pU�4�`��|�����,���f�0B�0׍�n@\L�+-cb/���Ld�U+��Z�$����L
q6���-}�O����qS3�՝T��<��l�������ݒ#LX���1��z�r�)SS�X%�¬z��Q�o�Q�wN�I�>��g(~��Y���۾���ٵF�����	t�'�Cu={e�P��x��ܼ����Է:~T�Ǜ߫�<>�y��kt���9?�*�ٓT7�W��-��-?��<~��8��,�d���i��@��͝Ŝc�,^�����v%t��T��<*8���
r�a��r�o���i/	�m��[U]�K�������t��2[W�IZ����=�[0�K/�(�aJ,���Ot�#���t� ���n�*<�*�������bz�2s�M��_�����Q%E&�g�A�y��Zs�ԏ�Տ��Ɣ������9�P�X�vy]@��r�Y�J\�vLSqDy�p�g���ѻ_<�M7�    
�->��U�Y�*k��܋Q%���:(3���o��R�W�ŝ.-�p�8ӔA�[�G8�=Η�3���|y��SL9�4�,�"�ykG$����L�E��B�%�S"ړ-(	e�<��ۨA�n�:�C�-	��ߕ���%/m��N�)V�U�]�f��d��'ם�qF}��UE�lp�	�F�WCa�j��;;wo8�6��F�;}�]�~d~�PƂ�C�|[2��Ǡ�lu�?�N�]@\,f�K@�uu]�CV���;�j]�Yk/gz@?�9�TBl��m����j��x7�c�=����~�. tP������J��+�>j1`��Y�-�5Ջ��������59:�2��6[��٤=���d[��/�`	���EOE, ��&�^�ܛ�∳�g�;�� ��'�U)��Ȥ�M��
<����;l��9���l���Yƨ�-���"�!9i�h�����Q��J���x�Q��i����M�FK�^��/���^�}w����@�_ݨ�_3tj�]�?o6�~��J�O5P��ɦY �S�^�	��q/3�o���mVn�i�V4`�|�x�Ȥ�:�(��7p��������E�L�S;��+5G"Jf�]I�v39m{�L(�D�h�H�׎	�L��"EO���Pfr62"J�!&î�&��@��$�g����fZ9=U�ʂt�M$���fI$"Q�@O.�0�`绫T�_g�5���hT�[Ni�"������d�O�ɘ��>-��|xP�;>s bI��!��"><��hX/��b��q)�5k���pM������%�zݗ3��D����J�r�W*Ẁqy?��#��N2ygz���\]��PD�z�	$	h9/j��1~�����X�C��.�C-�0�ߴ5Λ׷EIG�Ѹ8���t��׭E�f #���Y �È����qr�Imz=̼��^�)������`�(��<@�T�S�U!��H-ϾZ���r�֓�I��?����u��&i	���K�?�����/;����u�r�f��^��nb��,��tV%_?���[�Ð͂���%3.�d�sx�7�]�o,|r������%��v� kw��큿dc�I/s̛�ŇH��!��˴�mZz���G�2�;�M�6R;&�X����>�4����S+S�S�m��68�8�I���,�\<H��:���+}��R:�r�i�*�ޔ�)3Y��./��j��#��GVp��XH�m*to/n�l/�u(��a��4�ǒ�a�e�9�������~%DUL2)�g��8s��uD�QI���%�ɏ���M#�����ќME`ז�4¥��#ߜhX�Edr]���a�D��"}Vb[Γ<,�;����-֌e��{X�Mb���ZS��{�LЁ���I)�گ��}~���a�gQU\���gKr������l�Q����_�-\��[���;n��{"�֑�Ë�%U
S��$�\oD�m�땫��7�6���_g�M�y��� ��iy���~L�~^���o� �ވ����u����o!�m���6�����/��[b;,�-����.3S�k�xA���"���Ĳ�jãqp�����d���!к-r1�c�İeVȳ�`��t�^	q`z��@�n1w$u&jqRI�$��7��9HU�#�Ӗ
H�j(x��j��E�����r�����%� :	�!���	��a*��\J��+1��2�br6��26e�D�Գ��1ɭMsC�Ӻ�)>/h�cc�,yPt����0�ΈQ�n�0�
�c��i��$��\L�R�
Y�I%@S��Rf6�����W\e��r�`�'@J�R6u��/Qz���cVvrUŠZ uhj��`�|Z<��?��ԃr�����1k�̂)��f����*]*d��E�`R'|:��!�T8Q�&H�m���_.�e��_�c��U��~��RV�"�R�M�E��92F�8S��s��Ŝߍ%�T��TʧCWJ=��'�IbdO���AeYѓ��7�k9�0�y>, ���4�u�fr��ƣgo�����ca���8L�B,
aY���&����-��ht�Y'Vae����weŻr�����9��q��m�|�P="��U��kK����q�Ŵ����N81��n��<r(�u���%X{���p��]���g��ѕO[�8A�
�h�K���7썌����v����LSy9�a�7�B�$6ZV1�e����dU3)�g�a�Qm}qI�8���X�ڨ�]1c���upI�:��qO]Y�����'A���C�󢳉�|
���^d���h�WEvu���Vu����]��iB�P����X���eF�*����	�R��ldYl�s�뙓������0&o�X��*[�E��lr6���b'�=QTeY�a�M����r�yE?7�s�^���P�MNSH疜=��M �,)ɒN��b�B��|:�V��ӞǛ:ԅ$dƜXo���zM���1�F]��S��d�%�E�����M�}���{�@̝c�*�x���7T�-<,$�9���S�:���%�������t�#�6�����C��8�cH�~����zP�r�V����j��A��b��wI�� Қ�$Z�B5o��(�n�	v�:�`l^B=�Q��`���,
?_�TK}[a�I�\戆�~`'4��x�|z(�\���d�*ƕ(2)��d8���S		��|.�;ΤU��"J�Ď���։l{���A_��1��8���)�b�9�rѴiGcF\�L_!�So���h=������DRٙ���5��o�Q7��"�A}�%�?�_���2��Zm��VbI���Q�$_�L���Jӎ�?=Lh��2��J������A���.׹Ӡl=�v��Zi���P���o��߬6��*^?n��ͭ��!�ϋq�(���*��N3�$�W�Ƅ_�*�#fy�[�y��B��ɓ��G�ϒf�S��%w*�D�I!W?u�(r�{�K��
���hp��z����it%���po�	��6q����k�u#�]����f�=�j�M��^�X���^,����8){��.}��._��@���?N��5�ja�(���L��kou�w77O�Z���V�e?�?�����~k��y���Q�n���&h�rzs�	�	�/�kd�BL��������f�����:���[�:\��:��f����G`Opڴ{;d��a�w׶ݴ"Ϸ�yXU`��U���������}< �'�Эm8tL���վ�m6�k*�Bj���~����y��7ߩ�nv�0�`�?6��n ߀1�1I��e�|��w?X����+TwC���8�<���f��;b�Ѻ��Z	p\��|�j��2���%_#������,�~Q�Q&��l2e�E�yش��t���zܘ��x�+i�fᆼ�뽇�Z�uX�V�I���Ta���DM��w3{T�i�ݓ8�XD"g�[♛�ֹ�|E_M��com7p�t��ǥ�I]/����.iMLWwP��K�����3�<`X�jЫE�{�K�P���=9��
�Ţ\i^h�6�\h��ʿ�(�����P�wU�3)�*�g.���羪�aI�AM.�"�!��l��x"��Z[�7p��ʜ(GGiZ�bb������僞���nS�Bq��u�����a��"�f���N5n�Q]��?r�l�I���[p��:{��t��S;�C�]��Y̆.�mXj��Bc���W�������_o�kR h@���
����W�t���&��!&�,<��\�|�	���ھ�*l�®�$dqq��G�$�\{���a%&��ó�pB�M�'�Jx�&�{Zq\���1�Tx���6�pq���Vǚ�fu��Rgiuͯ���f��	���{m��'V,�����ܨ�w�
3N~���������	>0>��8�@u�f�V�q�����ݦ������i)���g�m�c���h#LJ�@�f4��(���°����m�By��Qv�0jQ��1@�Z�3�>ܲ�e%EVȳ�Hd-ӗ��� $  A  �A����,� W�tG�<�%�Fǆ�9s�G��0� }tWգ�@T9���{k�Ӄ����E��,�9�W��WR���_C��68/-DN$:�>�0?��Ƿ�a8+�@�t�}!nT1g��q[
�L&�M=f'G��7�I�tx`6�Vl��Λ�d�,���S�W%2��k�u^��{�2&��nXnw���s�SQ��rcּS�7o��˞w��-#�|���'&�`X�����[u�^t��	H{�ܖ��=��Pm�ͬ��V�Ĵ�����Af�h$hsiآ,R9�/<k�����Smdy�H���a�ڄ���^F�I�Q{��vS#�Ղ't�O�a�!��5o�.�fl��!K��O��G���F�������Vg�{�EE���⽳O]	�B)�t���%��'�#�ޜ}�y����v�i5�Ì�t]N���8��q&S�'#���q"!x-�v�L���h�3dk�����y����d���.N�p�\_��5���U]��fEo!��	M��dqq�/�-: �u<}X@�q �59ɾ
<�e.J�Y>�ʢ*'�,�&�"�@�^��x��I�D#��|{GN3"�v�֦�m�)_]���:j^��Ȋn��"������t�r̂0nK���G�#+<ɞv�`(l��Q������2�%y ��D����ۓ1�h[_zh�Ƙ��sux�K%^��S�t��� �Y%:��u��*���H�%�$Cu�6f��u&�p���r�H��HHCuU��0S��]n��X����a����_���0��2��u�h|91�@U"��
H�ˢZ����N�L��"hD@/)2�s�hx��c����O{�A>�.���!��^Кl��)��.�LtK�Y��|�qR�CCbJ�݄�����i��q�I]���S�7P��<���'b8����-�4�ctx�f�.	O�)^��s�ϋ�W�Uѯ�e&��l2�g�ȓ��s@+W�bc��Gg�<�$��;�lkv��H��]�~���P�f
]>��e#�L�xV	��h�s+h@�è|-�?X�ԬW:�O��ƐŕH���v�yBex1���,��`��m�����)x������O�u?e({/v��XSp�(�DK�[���P(uGZ����yB��n�%Zڤ�Lg��-k�'�α�����	'���*�\+�49�;�H����v)��-��Gy�0Z�4fð�o��|�����'�����9��K�&~~��&5�S�1�e^�t����wd��4����c��Lcw��@M��EMD�^�β{#����Y!�2�\�{bX	Y�~&�8����R�B���W�x�E;}UME�َ�0��w�q��z {���x������fu�ﰠ4�ó��=�^�ܛ[䘯ŭ"�FV&[�W,m�M@Z4wG���ܟ��߮ ���n1��h��k�IN�a+'s�4�$�N�1$�j;�nąP���,`�����)a@?�4���_�:2��0���Tׁr�L�.�����6��${���ML�B���C���T�,������w>�Āj�Z	f�"kl�����4{�I�?1���j���1�1-���.�Ĕ���,bM�A��&�@��l�聀1Ϲ���a�B��Š'�UX`�&�&�aFt����zՑ�y�r[��WG���^���ˏ�u�f�~�Z3��N<R\<�~	(�|q����.�-׼P���?�\�R<�SeI).[��^MB���J7뭃H��C��m�l���EM)�U��VP���ק�7+JH6�5�����8/��@7�_��A\I#E�SQ0o&tNr9�ɢ���0�Ft�2��2R���̟�iF��k6^-/�!r��LmY��	ir}Z��xJ�m��F&�,�o�F����ėz��	Q��j0�
�a�3�*����,�P������Oi1;�J݆u�.��}q�|`��*ZB�I���P�Y^PIf"��X��a�����aO
�OrFY�Ĩ��j 2)J�4N2�f̋�1�(n[Zsa[�����j�ʈ�X�ĝ#C�:���)�'�����26P�[��܂X`rD�z0@�=)lM��L�X}�]�&�ou��nn���ʼ�[T�Ǜ߫��<�4�E��~��>��]���:���·�O����*�z�y���7�y��ٻ�������tD�PM�-�o�����[1�̂�	9����2��8	�z��]Q�K���T�(�R�M�"#JC��E��\�s��K:�m��u��5���0���ָ+�'6"�z�34�-=b��,p>��&����4���@�_��Uظ��c��+(��허O(�$�H�����"Ls &�!�t�����E�p�>%�N���i���>QY4Qa��sw?\�m���4*�s=e��w|�5$tҖ�/?{f��{���nL��U�0��ž3�z���cg�UNk�e�9'�,Xb	��o��s�dZ�F!�C��2�-�o��aH��Ů��3+~�C�=�V�z5U��H���q{��su=�� J�
���Z��+=,qx����տ��ɲ���x|6��?��%����w�,RH�O.�)k��S0�Lh���"�
�_�M?Υ
��U�A&D��r�e4�r�%�V�Ɯe�"�S�:)VR�hXtJ��ƨ;9{��qP��.9M��z����G݅4p�	Վ�Դ3X��J�S��&lh��t}�.Xi��P沀CQ��ݲw�q�9wW^�G�o�㙫'���V"����������j��uW9��rx�n���VQo��K����ͦ���='
�I��\�S��˻�_���������u�d��AU6���߿���gq=!8�[i$������zz�'I�����b�c�4�( (� �a��$�r�Ҩ~F�{N )v�ot���0"a7Q��h�X�s�.&��&������J��@3:�(�~/�ե��Os|���~(��%B,�R$��=l�va��8�O���>�(5_1��N�ÕU�<�嚡����'P��-���]��� f˷�'a�PM^���\c4�1LB��'�qOJ�QU��,�&�I�㵴��/J%>D����4��M���U�+̌$p/x�]���\� ��!g��݇�-��ԫ�|/z։lmG��� ���u���@��$�y��5y�b��b��؂x��^$��$�׳yn�L��{��)�������*#s�B�,,zbX��J���3)�Ȱ��S3�,A�M�����;c�+�gՠ�~�E�����o��:B<?�o��:8����y\�ֳ��bN���׫�U�7���-/�+XM�7�>��P������]�n�u�;�` ��y�a���c�z�v���0��nsmv�yuh�̉z���D�$��cO�a�۰�����$�-x"-b��9��V�Oص�S �m�ph�%����ΫYp�����^�d+�ø'�U1�^S���o������ۿ��_��?���������_�/�/�����_�^�����EQ���@~Q����L������������������U����HC�j�ū��\�Q%�_LF�`T�>�+���ɰ_�#�:�勳���nuf�      )   �  x�MZ[�%1������y�^�W��פ1��Tʛ� ��CD����6W%2W�x��+:G����/e.�����?���{Q�+�������{��8v_��v����vG���w���}J������-�A>��-�;��W�]�}�s�����/�Z��+,m�7�����w�~���u���hn+�	�ڶo�o$�sF|�%߱�Z�}x��g»�:6J���ړw&�������55�am�w�G��[�B��=���n�+��e�=�}?�+|�Iף�5X	����r=�z梨�P�\s?_W�۟w��`�� S:3�P�����ŷ�lo��Y�}xAf�I��Q��AT�zתϸ�A:�4�w���R>��c6�S��#H���h/�ܢ�u,�y;o(�X�1/�Pm��M���c��u�]|�����9�/.�E�W��z��#OC����Y�[�t���=��l���g���g>��5k���#�W71{��)?�υ���s`� u"�؁���e�H���d�`����������6�[o�[.ۈ� ?sH�nGx�C;���c�����ԍY�獟٠q(�N\�o�K ߒ]�yA��a�\�1�".���Z"���UI�n�?�_�f��:B�L��^w�~C�=vV�1�_j�-��?�!�D3i���g-a��s�R�8������6�!/�g7����q��h��凸P%#66����憾�-{7I|6��6$�o.�S;L°k�2q�!J`���B�S!�Tu����ͺ�7��3�Ͼ��@�\~m�g�ɫ뢡]N1��ETC+l�)hAޯ��7z�}�KG��Y�:���ԛ�p��e���?	��*5�8 ME>�<����-�Pvv{�Y�+�b�%�>�[��i�!@4���q�{o_	��ռrô�q�C�G��j�������G��c�
���~m4���D�*$����N�U�ˀ�&�0i�9��4}��@	�c�>GZ����USG��DPsUC�����	�e{z��U��x���u 9.;/����4a��8�biݯz鑸�5��&���F�#d6��D��MP����t�N$b�`�+c�Jw�^k���;ҫm���A�g�[��I��O)�ׯ����%nu�0��ѝd 4Ki�YU�H���*C���nb&2�H=Ub���(P:�61�:e�َ�Ub�	�q��ˍOjwDvB�(���@��~�ڣ˥@�!���sT�m��ȧuop ;�4}�;�,��hi�MK�N��Z�ܗH���I�ӞMNF�̣�D����}��3����E�ΧFk���z��C��;���Urv�q\	���H���M��\Ȃ�!7�7�y�M-a{x�7��?�Cʦ�����HPl��Ћ�&�ȕ4�/���ڜ�����Q���6v�j�ѹ����$�@~�xh[�P���b��[�ស͓�G�=�BT0d;!S��f���&V�rf�
H2��ݪ�}�y���!�J������l-�|*�j}�+P�ɽm��))ߠ�HT�3|�8P��x4��=$��an�֎�����Z�!�R14��R۟�U�Q2�A���T:��Yէ3i�;H�����*`A��A�Х��W��"��c��l8�G�&�j�E������]KF%#�M��b�zr�ϭ�Z-�E��v�=�ʘ���a���3��w�4L�D����j��^�1��UD�t<('�P�;���Q+*��>��y+�ͪE ��f\�8������M	��O���i�Bp�脅��A�_��l�Z�z��X� �� B#4�v���(2�d�B(<7�ΐ�j�h�`�X�m�yw���~�-��V�Q�S�-��z8n��]��
���(��<�8�D�N'��/A"��N	�P�ښ���d���,�N�@Pk����F��@9r?�4$���3!	�J����ȑ�w+I�j0��_�1���Y	z���+A}DO�������J�	ΐ�]gY�j��Ws����]�$r����lB����F�;D�1R�U��}�[4�A��X�~�z�[5 ��_���~o�Q��3�:F��A&a�̩�K2t��5�S�i4��%���'�S=���1�B�;!��ti]��� �iB0�x�5�Fn��*���m���?�ճ�´�U%��4�*M�1BG��Vd���g��-��!�v?����ԑ����Y�*߅F���=!�k��x`u��g�Q*8����B����eh����������/H<!��U���36����&(�������U1��ضU�C�Ƞ@����d���4#b�"[�C�zA޺#4�j�b��) �f���S�T�n�o/����V�HЙA�P�V!��l�8�g�ά+sR��j��N&��Y���ub�E8�DWK�B~V�'2����ڌ�Á �m �.��*�����X��������g'5d��0JTm-؂�p2�n+3�Vl
9#�
�S۾��N�|��>
߆�OFtC�Uq�a�^8�@�� UQL9�4�6"9�l�6���_kI'Π0���hRs��u���5��ͽ�ɶ��ǉ3]/�2=�G4��|�o��r;fBhP�c,}��c1[�0�F]p��vPu��8D��t m�rT.��z[�+��=�ɯ>1[�!��� �̠���ȡ��$- 4y�y51�.cF�	�B5^�=��B�A~mE���Y�䎆����LPi�&��q�S<�wP�{�S�!z2f��b����~(A[*$Ѯ������4�$
@���
�E�x��PFC�Aw���!%J?��� eź3��G��+]�T �PI
�3Z@?��@dN�.
Fʄ���!'{�����a�y���
ʒI?��K4R�"8j��=��Z��$LÒ9s3F!f�����x%6+��(��O�ᜉ6	���څ����o�2�)5��\v�"h�o��M�%�c�ID.�
�=t��Ꙁˢy���,ؾo��L�0�����F$&�Q��qց/�@YhO7KL��"|J���R���N54c����)#^�M�-��'2��V0��z6f�f�5c\K	��5%�n*��:�?�bk�em?���,gߟK��(|��E��� ���t�K`r�M�ш1Z9��/>֦�������߿����      *     x����nGǯ'Oa�w�X����!$�8���f�ש�޵�mzE�"EJAi���RC[RQ�^&������w=�T�s����9�?_���i�+��{�~��]���w�7~��tt�K@@5>U����m���Z�׺�>��#�A������(cP�������ҩ9j���9��jka�V���F��^��7�T�UW��v6JA�99LX\P&m�T���_9z���t��4�߷�'.�2����?uz����4������fk�[�.=?�R�R���v�Q�2K[bfb��,��3��������<�+i�_���:���H������D��^�������b���r���xpu��xw�T �
�5N�vJ�)ϐ��H?����Įza���5x�����Woa�b�Ă�%b�h.�\�`��O��e��d|�Z��\�y'<�&J%Ĳ�9��ih�����0�Oưcn��n�ȣ�B*4�h�S��"��E��f;[Զ����K�X�t�WFb�8�|i�����/4t�[Ӈ#���nO=G��|�=UgP���B#�M�v�e6r�_�������������Xs{�$#�ڈ ���:�}�����O?�~�v���M��l�*KI�HA�u��Ϯ��c��0�����\PПt�� ���^:1��y�����ʴ����n�kV�jI�Bj�i����F?�:��/���riw<?�1g��mR�R��)�I*�I��U��`�`0ܽ7��5|s�"��NO&>��ɍΥ��;��E�w&|ڭf0�U�����TyD�������ebe�1���I�}skow�#qd?:���0NLq�H����������8�\����}!�W�7�U�u�2�8���3Ô�X�i��m��Jdt"�B;$Q}cĂL@,&�PGJ7�ZZU���y�X��?<$X�"��Y��\BN�*m[I^��sy}�C��ު?nQ$T�1@TW�S*�uՆ���HDF���^<^�*A'�����_��7aj���Z����ꋑ*�2�bmu�>����2[Y�*�pS:�W�����뽣s4
3g�f�12ݥ�nt��e�1�p�l���5�NU,*�;�ƅI(�p2]b"P4_�'r͚9��M!�����T��fIcԜ{`�ř���R�Jla"Y:���I�W���T��Me<�6�G��F0{��G[mEz�5޼���tx�޴tΩ���5@V�����`Fh�פ��'<����A��Н{o��pkW���f�B�*�p�y����3��!lI�0���`kJǫ���u.� o��D������Q�bCA��A�S>�V��e)��"���tA�an��A8�Ϣ��j�!�f�I[#�c�əO���SnH8�f�t�d� ���afg����H=��Ra�F�N���]��7��ʶ�n|j�"�ވ")��c��fY��;�=e���`.U���2_Sr�&���f������$U~��577����      ,   q   x�%���0�PL08N/���;��",<,������ӎ�* #x��n��bo����G!Wi��P^4�(h䦹�j�~x��/gQ�%'���+�lx�q�f\��������      -      x���MW�H����`qg	t�w�B�+�ET����@ �\��S�� ά�'+Ρ�P���6@)�E���`��?����NR:��d9<Ξ���۟0o�v��[����u8{m��,FY�E�l�xQ\e	Gcp�	����T���p9u� KRryչ}� ���g��G0�5��ڛd���\3*a)����B�+����/��u�yݻ �t��r��Qw�v5r�(���]���R���l�tV<��-�;��u2��<�=}��{Rk��g����Zp�/�!���+��Q��=MD7�H���Kq����>»��n�� 6>m'w��Y_R��x隧k�iqT�1���o��s����o>�
"���0���`�������f��ߌ��NhX^\�z>���s�E�QX���F:�*���X�Y6ۃX��;�4�IZ��r�e��FK��ƑL�1���t��h�JW�=�8`P�i�������;�@��EA�*c���]���PN��e����g�T�-T)�6V��z9�P�>J�!sϏ�5g�DQ|=�;m�*UU�+��`���Mz�8��%�"��C��P������
�j��!��ؔTg>*�e��� �����fP]�����!m/ϣEV�Jo��Gk�r��Q���P��7�P)� .)��_���t.�h.$����l�{;l
���I;*�2�'X�1>0h)%.-���]aU@�0��L�3h�Y��0/F���T!Ws��ֱ8+~�aH?J����a��f��H�ñ'b�Զ�b�:��v�/-&� �Ɠe9����V�s1R��u;cW�r�\[G?���=�zC�B9���|�j;��^��ϰ}$�p�y��D�|M��7}����7u8�|�\��5.=�|K�-c�ss����}y�1<�Ԛ����5��_׊���<�כ��N��=<��_����E�g��H��3��`�.?H�A��TF��G�B2�h}�*�8L����<��(R�uZ������s�%��y��9�~��vC�ͧ�r����w�k>�[��QP#Y�AË�u��k� f�����7�Jr�i�K�y�a��Fi5�g;�
&��K����E`�����{q��s�\�C���L]ZS�
��������S��v$ڈFqV���S,Fi	V lK�*UvS�ݎy�d�G����[�*5����
a�����`�}���"��!�{���ۿZڣ�=��u��m��}?�������?�t��      .      x�340�4400����� r      /   F   x�3�LL����tt����|�{��	��-|>�����w�pq��&�q���:�A�<�3*���� u( �     