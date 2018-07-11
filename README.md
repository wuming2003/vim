# Windows
Windows vim安装包可以从
https://github.com/wuming2003/vim/releases/download/depend/gvim81.exe
下载
1. 下载代码：
   ```
   cd %USERPROFILE%
   git clone https://github.com/wuming2003/vim.git vimfiles
   ```
2. 安装python所需文件(可选)
   python安装包可以从 
   https://github.com/wuming2003/vim/releases/download/depend/python-2.7.14.msi 
   下载
   ```
   pip install jedi
   pip install flake8
   ```
3. 安装shellcheck(可选)
   下载 
   https://github.com/wuming2003/vim/releases/download/depend/shellcheck-stable.zip 
   并拷贝到%PATH%路径下


# Linux
1. 下载代码：
   ```
   git clone https://github.com/wuming2003/vim.git ~/.vim
   ```
2. 配置一些有用的脚本(可选)
   修改.bashrc，添加
   ```
   export PAHT=~/.vim/bin:$PATH
   ```
   或者
   ```
   cp -af .vim/bin/* /usr/local/bin
   ```
3. 安装python所需文件(可选)
   ```
   pip install jedi
   pip install flake8
   ```
4. 安装shellcheck(可选)
   ```
   curl https://github.com/wuming2003/vim/releases/download/depend/shellcheck-stable.linux.x86_64.tar.xz
   tar -xvf shellcheck-stable.linux.x86_64.tar.xz
   cp shellcheck-stable/shellcheck /usr/local/bin
   ```

5. 配置
   修改.bashrc，添加
   ```
   export GIT_EDITOR=vim
   alias svnvidiff='svn diff --diff-cmd svn-diff-vim'
   export SVN_EDITOR=vi
   alias vi='vim'
   ```
   如果想禁用系统的/etc/vimrc，可以在.bashrc中加入
   ```
   alias vim='vim -u ~/.vim/vimrc'
   alias vi='vim -u ~/.vim/vimrc'
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
