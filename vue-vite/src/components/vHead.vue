<template>
  <header class="header-pc">
    <div class="header-left">
      <router-link to="/index" custom v-slot="{ navigate }">
        <div @click="navigate" class="logo">魔法空间</div>
      </router-link>
    </div>
    <nav>
      <router-link :to="item.path" v-for="item in navList" :key="item.title"
                   class="nav-item">
        <div>
          {{ item.title }}
        </div>
      </router-link>
    </nav>
    <div class="header-right"></div>
  </header>
  <header class="header-mobile">
    <router-link to="/index" custom v-slot="{ navigate }">
      <div @click="navigate" class="logo">Magisk Zone</div>
    </router-link>
    <div class="burger-nav">
      <div class="burger-icon" @click="openMobileNav = true">
        <svg id="menu-icon" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"
             x="0px" y="0px" viewBox="0 0 24 24">
          <line id="menu-line-top" class="menu-line" x1="1" y1="6" x2="23" y2="6" stroke-width="2.4"
                vector-effect="non-scaling-stroke"
                style="transform-origin: 0 0;"></line>
          <line id="menu-line-mid" class="menu-line" x1="1" y1="12" x2="23" y2="12" stroke-width="2.4"
                vector-effect="non-scaling-stroke"
                style="transform-origin: 0 0;"></line>
          <line id="menu-line-bot" class="menu-line" x1="1" y1="18" x2="23" y2="18" stroke-width="2.4"
                vector-effect="non-scaling-stroke"
                style="transform-origin: 0 0;"></line>
        </svg>
      </div>
    </div>
    <div class="mobile-nav" :class="{'open-mobile-nav': openMobileNav}">
      <div class="mobile-nav-top">
        <div class="nav-top-left"></div>
        <div class="nav-top-right">
          <div class="close-menu-icon" @click="openMobileNav = false">
            <svg version="1.1" xmlns="http://www.w3.org/2000/svg"
                 xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" viewBox="0 0 24 24">
              <line id="menu-line-top" class="menu-line" x1="1" y1="6" x2="23" y2="6" stroke-width="2.4"
                    vector-effect="non-scaling-stroke" data-svg-origin="12 6" style="transform-origin: 0 0;"
                    transform="matrix(-0.70711,-0.70711,0.70711,-0.70711,16.24266,24.72798)"></line>
              <line id="menu-line-bot" class="menu-line" x1="1" y1="18" x2="23" y2="18" stroke-width="2.4"
                    vector-effect="non-scaling-stroke" data-svg-origin="12 18" style="transform-origin: 0 0;"
                    transform="matrix(-0.70711,0.70711,-0.70711,-0.70711,33.2133,16.24266)"></line>
            </svg>
          </div>
        </div>
      </div>
      <div class="mobile-nav-main">
        <router-link :to="item.path" v-for="item in navList" :key="item.title" @click="openMobileNav = false"
                     class="mobile-nav-item">
          {{ item.title }}
        </router-link>
      </div>
    </div>
  </header>
</template>

<script lang="ts" setup>
import { reactive, ref } from "vue"

//手机端汉堡菜单
const openMobileNav = ref(false)


// nav列表数组
interface navList {
  title: string
  path: string
}

const navList = reactive<navList[]>([
  {
    title: "首页",
    path: "/index"
  }
])

</script>

<style lang="less" scoped>
.header-pc {
  padding: 0 10px;
  height: 60px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  @media only screen and (max-width: 768px) {
    display: none;
  }

  .header-left {
    min-width: 100px;

    .logo {
      cursor: pointer;
    }
  }

  nav {
    width: 100%;
    height: 100%;
    display: flex;
    align-items: center;

    .nav-item {
      color: rgb(78, 89, 105);
      text-decoration: none;
      height: 100%;
      display: flex;
      justify-content: center;
      align-items: center;
      position: relative;
      margin-left: 12px;

      & > div {
        padding: 5px 10px;

        &::before {
          content: "";
          position: absolute;
          left: 0;
          right: 0;
          bottom: 0;
          height: 3px;
          width: calc(100% - 20px);
          background-color: transparent;
          transition: all 0.3s;
          margin: auto;
        }

      }

      &:hover > div {
        background-color: #F2F3F5;
      }
    }

    .router-link-active {
      & > div {
        color: rgb(22, 93, 255);

        &:hover {
          background-color: #F2F3F5;
        }

        &::before {
          background-color: #165DFF;
        }
      }
    }
  }
}

.header-right {
  min-width: 130px;

  .darkmode-switch {
    display: flex;
    justify-content: center;
    align-items: center;
    cursor: pointer;

    span {
      margin-right: 10px;
    }
  }

}


.header-mobile {
  padding: 0 10px;
  height: 60px;
  display: none;
  align-items: center;
  justify-content: space-between;
  @media only screen and (max-width: 768px) {
    display: flex;
  }

  .logo {
    min-width: 100px;
    cursor: pointer;
  }

  .burger-nav {
    display: flex;

    .darkmode-switch {
      display: flex;
      justify-content: center;
      align-items: center;
      cursor: pointer;

      span {
        margin-right: 10px;
      }
    }

    .burger-icon {
      margin-left: 10px;
      width: 25px;
      height: 25px;
      cursor: pointer;

      #menu-icon {
        line {
          stroke: rgb(0, 0, 0);
        }
      }
    }
  }

  .mobile-nav {
    background-color: rgb(241, 241, 241);
    position: fixed;
    width: 100vw;
    height: 100vh;
    top: 0;
    left: 100vw;
    pointer-events: none;
    opacity: 0;
    transition: 0.3s ease-in-out;
    padding: 20px;

    .mobile-nav-top {
      height: 30px;
      display: flex;
      justify-content: space-between;
      align-items: center;

      .nav-top-right {
        .close-menu-icon {
          height: 25px;
          width: 25px;
          cursor: pointer;

          svg {
            height: 100%;
            width: 100%;

            line {
              stroke: rgb(0, 0, 0);
            }
          }
        }
      }
    }

    .mobile-nav-main {
      margin-top: 10px;

      .mobile-nav-item {
        display: block;
        color: #000;
        text-decoration: none;
        font-size: 18px;
        margin: 10px 0;
      }
    }
  }

  .open-mobile-nav {
    opacity: 1;
    left: 0;
    pointer-events: inherit;
  }
}

body[arco-theme='dark'] {
  header {
    background-color: #232324;
  }

  .header-pc {
    nav {
      .nav-item {
        color: rgb(201, 205, 212);

        &:hover > div {
          background-color: #2C2C2D;
        }
      }

      .router-link-active {
        & > div {
          color: rgb(255, 255, 255);

          &:hover {
            background-color: #2C2C2D;
          }

          &::before {
            background-color: rgb(22, 93, 255);
          }
        }
      }
    }
  }

  .header-mobile {
    .burger-nav {
      .burger-icon {
        #menu-icon {
          line {
            stroke: rgb(255, 255, 255);
          }
        }
      }
    }

    .mobile-nav {
      background-color: #191919;

      .mobile-nav-top {
        .nav-top-right {
          .close-menu-icon {
            svg {
              line {
                stroke: #fff;
              }
            }
          }
        }
      }

      .mobile-nav-main {
        .mobile-nav-item {
          color: #fff;
        }
      }
    }
  }
}
</style>
