#killall nginx

rm *temp -rf

#NGINX="/data/openresty1915/nginx/sbin/nginx"
NGINX="/usr/local/openresty/nginx/sbin/nginx"
$NGINX -p `pwd` -c conf/nginx.conf
$NGINX -p `pwd` -c conf/stable.conf
$NGINX -p `pwd` -c conf/beta1.conf
$NGINX -p `pwd` -c conf/beta2.conf
$NGINX -p `pwd` -c conf/beta3.conf
$NGINX -p `pwd` -c conf/beta4.conf

#/usr/local/openresty/nginx/sbin/nginx -p `pwd` -c conf/nginx.conf  
#/usr/local/openresty/nginx/sbin/nginx -p `pwd` -c conf/stable.conf 
#/usr/local/openresty/nginx/sbin/nginx -p `pwd` -c conf/beta1.conf  
#/usr/local/openresty/nginx/sbin/nginx -p `pwd` -c conf/beta2.conf  
#/usr/local/openresty/nginx/sbin/nginx -p `pwd` -c conf/beta3.conf  
#/usr/local/openresty/nginx/sbin/nginx -p `pwd` -c conf/beta4.conf  
