server {
	    listen 80;
	
	    server_name _;

	    return 301 https://$host$request_uri;
}


server {
            listen 443;
            root /var/www/html/wordpress/;
            index index.php index.html;
            server_name test-wp.com www.test-wp.com;


	    ssl    on;
	    ssl_certificate    /etc/openssl/server.crt;
	    ssl_certificate_key    /etc/openssl/server.key;


            location / {
                         try_files $uri $uri/ index.php?$args;
            }

            location ~ \.php$ {
                         include snippets/fastcgi-php.conf;
                         fastcgi_pass unix:/run/php/php8.1-fpm.sock;
            }
            
            location ~ /\.ht {
                         deny all;
            }

            location = /favicon.ico {
                         log_not_found off;
                         access_log off;
            }

            location = /robots.txt {
                         allow all;
                         log_not_found off;
                         access_log off;
           }
       
            location ~* \.(js|css|png|jpg|jpeg|gif|ico)$ {
                         expires max;
                         log_not_found off;
           }
}
