---
layout: post
title: Vue javascript framework
date: 2023-01-25 12:21 +0800
published: false 
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
