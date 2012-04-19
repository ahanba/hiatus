#coding: utf-8

#http://photoq-1989.blogspot.jp/2010/04/kconv.html
#Kconv が全角カナを半角カナに自動で変えてしまう問題の対応

  require "kconv"
   
  module Kconv
    def tojis(str)
      ::NKF::nkf('-jxm0', str)
    end
    module_function :tojis
    
    def toeuc(str)
      ::NKF::nkf('-exm0', str)
    end
    module_function :toeuc
    
    def tosjis(str)
      ::NKF::nkf('-sxm0', str)
    end
    module_function :tosjis
    
    def toutf8(str)
      ::NKF::nkf('-wxm0', str)
    end
    module_function :toutf8
    
    def toutf16(str)
      ::NKF::nkf('-w16xm0', str)
    end
    module_function :toutf16
    
    #def kconv(str,out_code, in_code)
    #  ::NKF::nkf('-jxm0 -exm0 -sxm0 -wxm0 -w16xm0', str)
    #end
    module_function :kconv
  end
  
