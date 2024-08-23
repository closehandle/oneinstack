/*
load_module /usr/lib/nginx/modules/ngx_http_js_module.so;

http {
    js_path /etc/nginx/njs;
    js_import ratelimit from ratelimit.js;
    js_shared_dict_zone zone=example_com:10m timeout=3600s evict;

    server {
        location ~ [^/]\.php(/|$) {
            js_var $rl_zone example_com;
            js_var $rl_name $remote_addr;
            js_var $rl_time 10000;
            js_var $rl_size 20;
            js_set $rl_data ratelimit.action;

            if ($rl_data != '') {
                add_header Content-Type text/html always;
                return 429 $rl_data;
            }
        }
    }
}
*/

function action(r) {
    const zone = r.variables['rl_zone'];
    const list = zone && ngx.shared && ngx.shared[zone];
    if ( !list ) return '';

    const name = r.variables['rl_name'] || r.variables['remote_addr'];
    const time = Number(r.variables['rl_time']) || 10000;
    const size = Number(r.variables['rl_size']) || 30;
    const date = Date.now();

    let data = list.get(name);
    if (data === undefined || data.length === 0) {
        list.set(name, JSON.stringify({ date: date, size: 1 }));
        return '';
    }

    try {
        data = JSON.parse(data);
    } catch (e) {
        list.set(name, JSON.stringify({ date: date, size: 1 }));
        return '';
    }

    if (date - data.date > time) {
        data.date = date;
        data.size = 1;
    } else {
        data.size++;
    }

    let done = false;
    if (data.size > size) {
        data.date = date;
        done = true;
    }
    list.set(name, JSON.stringify(data));

    if (done) {
        return `<html>
<head>
    <title>429 Too Many Requests</title>
</head>
<body>
    <center><h1>429 Too Many Requests</h1></center>
    <center><h1>You can <b>retry after ${Math.ceil(time / 1000)} seconds</b></h1></center>
    <center><h1><b>DO NOT REFRESH</b> at this period, otherwise the timer will reset</h1></center>
    <hr>
    <center>nginx</center>
</body>
</html>`;
    } else {
        return '';
    }
}

export default { action };
