---
layout: post
title: Vue javascript framework
date: 2023-01-25 12:21 +0800

---


## First Vue Project

![Desktop View](/assets/img/2023-01-25-vue-javascript-framework/1.png){: width="600" height="500" }
 <script  type='text/javascript' src=''>

     <script src="https://unpkg.com/vue@next"></script>



### Html 和 JavaScript交握


![Desktop View](/assets/img/2023-01-25-vue-javascript-framework/2.png){: width="600" height="500" }

## Vue指令

### v-model
如下
 <script  type='text/javascript' src=''>

    <div id="app">  {{ FullfirstName() }}   
    <label>First Name</label>
    <input type="text" v-model="firstName" />
    </div>
    <script src="https://unpkg.com/vue@next"></script>
    <script>
    Vue.createApp({
        data() {
            return {
                firstName: 'HiJack'
            }
        },
        methods:{
        FullfirstName() {
            return  `${this.firstName}`
            }
        }
    }).mount('#app')
    </script>


### v-bind
使用v-bind傳遞變數到html的作法
![Desktop View](/assets/img/2023-01-25-vue-javascript-framework/3.png){: width="600" height="500" }

### v-html
javaScript插入DOM的方式
![Desktop View](/assets/img/2023-01-25-vue-javascript-framework/4.png){: width="600" height="500" }
 <script  type='text/javascript' src=''>

    <div id="app">
    <p v-html="GoogleURL_HTML"></p>
    </div>
    <script src="https://unpkg.com/vue@next"></script>
    <script>
    Vue.createApp({
        data() {
            return {
                GoogleURL_HTML:'<a href="https://Google.com" target="_blank">Google</a>'
            }
        }
    }).mount('#app')
    </script>

### v-on click 事件觸發
如下,使用v-on:click
<script  type='text/javascript' src=''>

    <div id="app">
    <p>{{ age }}</p>
     <button type="button" v-on:click="Addition">Addition</button>
    <button type="button" v-on:click="age--">Subtraction</button>
    </div>
    <script src="https://unpkg.com/vue@next"></script>
    <script>
    Vue.createApp({
        data() {
            return {
                age:20
            }
        },
        methods:
        {
        Addition(){this.age++}
        }
    }).mount('#app')
    </script>


或使用v-on:[input]
<script  type='text/javascript' src=''>

    <div id="app">  {{ FullfirstName() }}   
    <hr />
    <label>First Name</label>
    <input type="text" v-model="firstName" />
    <label>Last Name</label>
    <input type="text" v-model="lastName" v-on:input="updateLastName" />
    </div>
    <script src="https://unpkg.com/vue@next"></script>
    <script>
    Vue.createApp({
        data() {
            return {
                firstName: 'HiJack'
            }
        },
        methods:{
        FullfirstName() {
                return `${this.firstName} ${this.lastName}`
            },
            updateLastName(event)
            {
                this.lastName=event.target.value
            }
        }
    }).mount('#app')
    </script>



### v-on click 傳遞參數
下面這個範例可以在輸入TextBox時,按F12看Console結果
<script  type='text/javascript' src=''>

   <div id="app">  {{ FullfirstName() }}   
    <hr />
    <label>First Name</label>
    <input type="text" v-model="firstName" />
    <label>Last Name</label>
    <input type="text" v-model="lastName" v-on:input="updateLastName('Hello',$event)" />
    </div>
    <script src="https://unpkg.com/vue@next"></script>
    <script>
    Vue.createApp({
        data() {
            return {
                firstName: 'TEST'
            }
        },
        methods:{
        FullfirstName() {
                return `${this.firstName} ${this.lastName}`
            },
            updateLastName(Msg,event)
            {
                console.log(Msg);
                this.lastName=event.target.value
            }
        }
    }).mount('#app')
    </script>


### Computed
![Desktop View](/assets/img/2023-01-25-vue-javascript-framework/5.png){: width="600" height="500" }
<script  type='text/javascript' src=''>

    <style>
        .circle {
            width: 150px;
            height: 150px;
            border-radius: 100%;
            background-color: #45D619;
            text-align: center;
            color: #fff;
            line-height: 150px;
            font-size: 32px;
            font-weight: bold;
        }
        .purple {
            background-color: #767DEA;
        }
    </style>
    <div id="app">
        <label>
            <input type="checkbox" v-model="isPurple" /> Purple
        </label>

        <div class="circle" :class="circle_class">
            Hi!
        </div>
        </div>
        <script src="https://unpkg.com/vue@next"></script>
        <script>
        let vm = Vue.createApp({
        data() {
            return {
                isPurple:false
            }
        },
        computed: {
            circle_class() {
                return {purple: this.isPurple}
            }
        }
    }).mount('#app')
        </script>


### 條件渲染
<p>v-show也能做到條件渲染,但使用細節可能跟if不太一樣</p>
詳見[https://vuejs.org/guide/essentials/conditional.html#v-show](https://vuejs.org/guide/essentials/conditional.html#v-show)
範例如下
<script  type='text/javascript' src=''>

    <div id="app">
        <p v-if="model == 1"> model=1</p>
        <p v-else-if="model == 2"> model=2</p>
        <p v-else"> other</p>

        <select v-model="model">
            <option value="1">if</option>
            <option value="2">else if</option>
            <option value="3">else </option>
        </select>
        </div>
        <script src="https://unpkg.com/vue@next"></script>
        <script>
        let vm = Vue.createApp({
        data() {
            return {
                model:1
            }
        }
    }).mount('#app')
        </script>

### componet的使用方式

如下
範例如下
<script  type='text/javascript' src=''>

    <div id="app">
        <hello></hello>
        <hello></hello>
        <hello></hello>
        </div>
        <script src="https://unpkg.com/vue@next"></script>
        <script>
    let vm = Vue.createApp({
      //  template: ``
    })

    vm.component('hello', {
      template: `<h1>{{ message }}</h1>`,
      data() {
        return {
          message: 'Hello World!'
        }
      }
    })

    vm.mount('#app')
        </script>



## 常用工具-PowerShell
### Vite
<p>開啟PowerShell，依序輸入紅框中的指令</p>
![Desktop View](/assets/img/2023-01-25-vue-javascript-framework/6.png){: width="600" height="500" }
<script  type='text/javascript' src=''>

    npm create vite@latest

<p>完成之後，會產出一個vite專案，裡面的資料大致上有這些</p>
![Desktop View](/assets/img/2023-01-25-vue-javascript-framework/7.png){: width="600" height="500" }
<p>可以使用PowerShell啟動Vite Server</p>
![Desktop View](/assets/img/2023-01-25-vue-javascript-framework/8.png){: width="600" height="500" }
![Desktop View](/assets/img/2023-01-25-vue-javascript-framework/9.png){: width="600" height="500" }
<script  type='text/javascript' src=''>

    npm run dev


<p>「npm run build」可能是產生要放到IIS的檔案,備註:我還沒試過</p>


### SASS
<p>備註:SASS 是用來加速CSS開發</p>
<p>安裝SASS</p>
![Desktop View](/assets/img/2023-01-25-vue-javascript-framework/10.png){: width="600" height="500" }
<script  type='text/javascript' src=''>

     npm install sass



<p>因為sass是用來加速開發css的語言,所以確定要使用sass的話,原本的副檔名要從css要改成scss</p>
![Desktop View](/assets/img/2023-01-25-vue-javascript-framework/11.png){: width="600" height="500" }
<p>改成sass最大的好處是可以結構化管理css</p>
![Desktop View](/assets/img/2023-01-25-vue-javascript-framework/12.png){: width="600" height="500" }

### ESLink
<p>備註:ESLink 用來檢查JavaScript程式碼是否符合規則</p>
[https://eslint.org/](https://eslint.org/)
<p>安裝ESLink </p>

![Desktop View](/assets/img/2023-01-25-vue-javascript-framework/13.png){: width="600" height="500" }
<script  type='text/javascript' src=''>

     npm install eslint --save-dev


<p>為vite配置eslint外掛 </p>
![Desktop View](/assets/img/2023-01-25-vue-javascript-framework/14.png){: width="600" height="500" }
<script  type='text/javascript' src=''>

       npm install vite-plugin-eslint --save-dev --force


<p>配置ESLink </p>

## 常用工具-VS Code
### ESLint
<p>安裝ESLint </p>
![Desktop View](/assets/img/2023-01-25-vue-javascript-framework/21.png){: width="600" height="500" }
<p>設定儲存時自動格式化 </p>
![Desktop View](/assets/img/2023-01-25-vue-javascript-framework/23.png){: width="600" height="500" }
<p>設定儲存時自動使用ESLint修正語法 </p>
![Desktop View](/assets/img/2023-01-25-vue-javascript-framework/25.png){: width="600" height="500" }
<script  type='text/javascript' src=''>

    "editor.codeActionsOnSave": {
        "source.fixAll.eslint": true
    }


### vee-validate
進行驗證用的外掛套件
在專案底目錄下,使用這指令安裝
<script  type='text/javascript' src=''>

    npm i vee-validate





### Prettier - Code formatter
<p>Prettier - Code formatter</p>
![Desktop View](/assets/img/2023-01-25-vue-javascript-framework/22.png){: width="600" height="500" }
<p>設定儲存時自動格式化 </p>
![Desktop View](/assets/img/2023-01-25-vue-javascript-framework/24.png){: width="600" height="500" }
### Tailwind
### Pinia
![Desktop View](/assets/img/2023-01-25-vue-javascript-framework/26.png){: width="600" height="500" }


## Html to Vue

### 靜態Html配置到Vue專案中

![Desktop View](/assets/img/2023-01-25-vue-javascript-framework/27.png){: width="600" height="500" }
### 結構化各個html部分
<p>例如移動Header </p>
<p>建立新的Vue檔,將Header移到新的vue中 </p>
![Desktop View](/assets/img/2023-01-25-vue-javascript-framework/28.png){: width="600" height="500" }

## 快速搭建Vue專案
### 指令建立初始專案
![Desktop View](/assets/img/2023-01-25-vue-javascript-framework/15.png){: width="600" height="500" }
<script  type='text/javascript' src=''>

       npm init vue@latest



### 使用vee-validate驗證資料
在專案底目錄下,使用這指令安裝vee-validate
<script  type='text/javascript' src=''>

    npm i vee-validate


導入vee-validate
![Desktop View](/assets/img/2023-01-25-vue-javascript-framework/29.png){: width="600" height="500" }
html標籤轉為vee
![Desktop View](/assets/img/2023-01-25-vue-javascript-framework/30.png){: width="600" height="500" }


安裝驗證規則vee-validate的驗證規則
<script  type='text/javascript' src=''>

    npm i @vee-validate/rules


導入vee-validate/rules
![Desktop View](/assets/img/2023-01-25-vue-javascript-framework/31.png){: width="600" height="500" }

<p>遷換到專案底下,安裝npm並執行專案</p>
![Desktop View](/assets/img/2023-01-25-vue-javascript-framework/16.png){: width="600" height="500" }
<script  type='text/javascript' src=''>

       npm run dev


### App.vue的Hello World
Source Code如下
<script  type='text/javascript' src=''>

        <template>
        <p> {{ '{{' }} msg }} </p>
        </template>
        <script>
        export default{
        name:'測試',
        data(){
            return {
            msg : 'Output Text'
            }
        }
        }
        </script>

<p>執行結果</p>
![Desktop View](/assets/img/2023-01-25-vue-javascript-framework/17.png){: width="600" height="500" }


### App.vue的component結構化
![Desktop View](/assets/img/2023-01-25-vue-javascript-framework/18.png){: width="600" height="500" }

### App.vue的component傳遞參數
![Desktop View](/assets/img/2023-01-25-vue-javascript-framework/19.png){: width="600" height="500" }


### App.vue的component傳遞事件
![Desktop View](/assets/img/2023-01-25-vue-javascript-framework/20.png){: width="600" height="500" }
