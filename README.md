# Windows
1. 下载代码：
   ```
   cd %HOME%
   git clone https://github.com/wuming2003/vim.git vimfiles
   ```
2. 安装python所需文件
   ```
   pip install jedi
   pip install flake8
   ```
Windows安装包可以从
ftp://ftp.vim.org/pub/vim/pc/gvim81.exe
下载

# Linux
1. 下载代码：
   ```
   git clone https://github.com/wuming2003/vim.git ~/.vim
   ```
2. 拷贝文件
   ```
   cp -af .vim/bin/* /usrlocal/bin
   ```
3. 安装python所需文件
   ```
   pip install jedi
   pip install flake8
   ```
4. 配置
   修改.bashrc，添加
   ```
   export GIT_EDITOR=vim
   alias svnvidiff='svn diff --diff-cmd svn-diff-vim'
   export SVN_EDITOR=vi
   ```

# Linux从代码编译vim
1. 下载代码
```
   git clone https://github.com/vim/vim
```
2. 编译
```
./configure --enable-pythoninterp=yes --prefix=/opt/vim/
make 
sudo make install
```
3. 配置
修改.bashrc，添加
```
export PATH=/opt/vim/bin:$PATH
```


