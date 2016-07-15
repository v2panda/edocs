'use strict';
var React = require('react-native');
var AdSupportIOS = require('AdSupportIOS');
var Home = require('./views/home');
var About = require('./views/about');
var Manager = require('./views/manager');
var Message = require('./views/message');
var Util = require('./views/util');
var Service = require('./views/service');

var {
  StyleSheet,
  View,
  TabBarIOS,
  Text,
  NavigatorIOS,
  AppRegistry,
  Image,
  TextInput,
  StatusBarIOS,
  ScrollView,
  TouchableHighlight,
  ActivityIndicatorIOS,
  AlertIOS,
  AsyncStorage,
} = React;


StatusBarIOS.setStyle('light-content');
var Address = React.createClass({
  // 声明静态方法、变量
  statics: {
    title: '主页',
    description: '选项卡'
  },

  getInitialState: function(){
    return {
      selectedTab: 'home',
      // View的style
      showIndex: {
        height:0,
        opacity:0
      },
      // ScrollView的style
      showLogin:{
        flex:1,
        opacity:1
      },
      isLoadingShow: false
    };
  },

  // 该方法调用在render后，在该方法中
  // ReactJS会使用render方法返回的虚拟DOM对象来创建真实DOM结构
  componentDidMount: function() {
    var that = this;
    // 向AsyncStorage获取token，再向服务器验证token是否有效
    // 验证失败则显示登陆组件
    AsyncStorage.getItem('token',function(err, token){
      if(!err && token){
        var path = Service.host + Service.loginByToken;

        Util.post(path, {
          token:token
        },function(data){
          /*
            数据返回格式是 
            {
              status:0或1
              data：xxx
            }
          */
          if(data.status){
            that.setState({
              showLogin:{
                height:0,
                width:0,
                flex:0,
              },
              showIndex:{
                flex:1,
                opacity:1
              },
              isLoadingShow:false
            });
          }
        });
      }else{
        that.setState({
          showIndex: {
            height:0,
            opacity:0,
          },
          showLogin:{
            flex:1,
            opacity:1
          },
          isLoadingShow: false
        });
      }
    });

    var path = Service.host + Service.getMessage;
    var that = this;
    Util.post(path, {
      key: Util.key
    }, function(data){
      that.setState({
        // 拿到message值，赋给data
        data: data
      });
    });
  },

  // 点击更换
  _selecTab: function(tabName) {
    this.setState({
      selectedTab: tabName
    });
  },

  //统一添加Navigator
  _addNavigator: function(component, title){
    var data = null;
    if (title === '公告') {
      data = this.state.data;
    }
    return <NavigatorIOS
      style={{flex=1}}
      barTintColor='#007AFF'
      titleTextColor="#fff"
      tintColor="#fff"
      translucent={false}
      initialRoute={{
          component: component,
          title: title,
          passProps:{
            data: data
          }
        }}
      />;
  },

  // 设置保存Email和password
  _getEmail: function(val){
    var email = val;
    this.setState({
      email: email
    });
  },

  _getPassword: function(val){
    var password = val;
    this.setState({
      password: password
    });
  },

  _login: function(val){
    var email = this.state.email;
    var password = this.state.password;
    var path = Service.host + Service.login;
    var that = this;

    // 隐藏登陆页 & 加载loading
    that.setState({
      showLogin: {
        height:0,
        width:0,
        flex:0,
      },
      isLoadingShow: true
    });
    AdSupportIOS.getAdvertisingTrackingEnabled(function(){
      // 获取设备ID 即deviceId
      AdSupportIOS.getAdvertisingId(function(deviceId){
        Util.post(path,{
          email: email,
          password: password,
          deviceId: deviceId,
        },function(data){
          /*
            数据返回格式是 
            {
              status:0或1
              data：xxx
            }
          */
          if (data.status) {
            var user = data.data;
            AsyncStorage.multiSet([
                ['username', user.username],
                ['token', user.token],
                ['userid', user.userid],
                ['email', user.email],
                ['tel', user.tel],
                ['partment', user.partment],
                ['tag', user.tag],
              ],function(err){
                if(!err) {
                  that.setState({
                  showLogin: {
                    height:0,
                    width:0,
                    flex:0,
                  },
                  showIndex:{
                    flex:1,
                    opacity:1
                  },
                  isLoadingShow: false
                });
                }
              });
          }else{
            AlertIOS.alert('登录', '用户名或者密码错误');
            that.setState({
              showLogin: {
                flex:1,
                opacity:1
              },
              showIndex:{
                height:0,
                width:0,
                flex:0,
              },
              isLoadingShow: false
            });
          }
        });
      }, function(){
        AlertIOS.alert('设置','无法获取设备唯一标识');
      });
    }, function(){
      AlertIOS.alert('设置','无法获取设备唯一标识，请关闭设置->隐私->广告->限制广告跟踪');
    });
  }，

  // 返回组件结构
  render: function(){
    return(
      <View style={{flex=1}}>
      // isloadingShow为true 显示ActivityIndicatorIOS
       {this.state.isLoadingShow ?
        <View style={{flex:1, justifyContent:'center', alignItems:'center'}}>
        <ActivityIndicatorIOS size="small" color="#268DFF"></ActivityIndicatorIOS>
        </View> : null
       }
       // isloadingShow为false 初始化界面
       {!this.state.isLoadingShow ? 
        <View style={this.state.showIndex}>

          //初始化tabbar
          <TabBarIOS barTintColor="#FFF">
          <TabBarIOS.Item
            // 加载本地图片
            icon={require('Image!phone_s')}
            title="首页"
            // this.state.selectedTab 等于 'home' 为true 则被选中
            selected={this.state.selectedTab === 'home'}
            onPress={this._selectTab.bind(this, 'home')}
            >
            // 添加导航栏
            {this._addNavigator(Home, '主页')}
          </TabBarIOS.Item>

          <TabBarIOS.Item
            title="公告"
            icon={require('image!gonggao')}
            selected={this.state.selectedTab === 'message'}
            onPress={this._selectTab.bind(this, 'message')}
            >
            {this._addNavigator(Message, '公告')}
          </TabBarIOS.Item>
          <TabBarIOS.Item
                title="管理"
                icon={require('image!manager')}
                selected={this.state.selectedTab === 'manager'}
                onPress={this._selectTab.bind(this, 'manager')}
                >
                {this._addNavigator(Manager, '管理')}
              </TabBarIOS.Item>

              <TabBarIOS.Item
                title="关于"
                icon={require('image!about')}
                selected={this.state.selectedTab === 'about'}
                onPress={this._selectTab.bind(this, 'about')}
                >
                {this._addNavigator(About, '关于')}
              </TabBarIOS.Item>
          </TabBarIOS>
        </View> : null
       }

       <ScrollView style={[this.state.showLogin]}>
          <View style={styles.container}>
            <View>
              <Image style={styles.logo} source={require('image!logo')}></Image>
            </View>

            <View style={styles.inputRow}>
              <Text>邮箱</Text><TextInput style={styles.input} placeholder="请输入邮箱" onChangeText={this._getEmail}/>
            </View>
            <View style={styles.inputRow}>
              <Text>密码</Text><TextInput style={styles.input} placeholder="请输入密码" password={true} onChangeText={this._getPassword}/>
            </View>

            <View>
              <TouchableHighlight underlayColor="#fff" style={styles.btn} onPress={this._login}>
                <Text style={{color:'#fff'}}>登录</Text>
              </TouchableHighlight>
            </View>
          </View>
       </ScrollView>

      </View>
    );
 }
});


var styles = StyleSheet.create({
  container:{
    marginTop:50,
    alignItems:'center',
  },
  logo:{
    width:100,
    height:100,
    resizeMode: Image.resizeMode.contain
  },
  inputRow:{
    flexDirection:'row',
    alignItems:'center',
    justifyContent: 'center',
    marginBottom:10,
  },
  input:{
    marginLeft:10,
    width:220,
    borderWidth:Util.pixel,
    height:35,
    paddingLeft:8,
    borderRadius:5,
    borderColor:'#ccc'
  },
  btn:{
    marginTop:10,
    width:80,
    height:35,
    backgroundColor:'#3BC1FF',
    justifyContent:'center',
    alignItems:'center',
    borderRadius: 4,
  }
});

AppRegistry.registerComponent('addressbook', () => Address);
