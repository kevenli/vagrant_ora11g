# vagrant_ora11g
vagrant oracle 11g，通过vagrant快速启动包含oracle 11g服务的虚拟机，可以用于开发环境的搭建。


Requirements: 

* vagrant


说明：

* Oracle软件和服务会在启动时自动根据配置的参数安装
* 安装oracle所需的puppet module已经放在puppet文件夹下
* 安装所需的参数大部分放在puppet/hieradata/oradb.example.com.yaml文件中了，还有一部分参数在puppet/manifest/oradb.pp文件中，可以根据需要自行修改
* vagrant启动时使用centos-6.6-x86_64，没有的话会自动下载，为了提高启动速度可以手动下载，通过vagrant box add命令添加到主机，box下载地址    

    https://dl.dropboxusercontent.com/s/ijt3ppej789liyp/centos-6.6-x86_64.box

* 系统账号

    root/vagrant
    oracle/oracle



启动：

1. 将oracle 软件包linux.x64_11gR2_database_1of2.zip和linux.x64_11gR2_database_2of2.zip 拷贝到software文件夹
2. vagrant up oradb 启动虚拟机
3. 启动完成后oracle服务已经启动起来，可以直接连接    10.10.10.5/test.oracle.com  
4. sys账号密码：Welcome01
 
