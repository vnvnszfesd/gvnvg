FROM nginx:latest
MAINTAINER ifeng <https://t.me/HiaiFeng>
EXPOSE 80
USER root

RUN apt-get update && apt-get install -y supervisor wget unzip

# 定义 UUID 及 伪装路径,请自行修改.(注意:伪装路径以 / 符号开始,为避免不必要的麻烦,请不要使用特殊符号.)
ENV UUID 454fd4dd-3cd0-416f-95b1-eb1f66cd5e24
ENV VMESS_WSPATH /454fd4dd-3cd0-416f-95b1-eb1f66cd5e24-vmess
ENV VLESS_WSPATH /454fd4dd-3cd0-416f-95b1-eb1f66cd5e24-vless

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY nginx.conf /etc/nginx/nginx.conf

RUN mkdir /etc/v2ray /usr/local/v2ray
COPY config.json /etc/v2ray/
COPY entrypoint.sh /usr/local/v2ray/

# 感谢 fscarmen 大佬提供 Dockerfile 层优化方案
RUN wget -q -O /tmp/v2ray-linux-64.zip https://github.com/v2fly/v2ray-core/releases/download/v4.45.0/v2ray-linux-64.zip && \
    unzip -d /usr/local/v2ray /tmp/v2ray-linux-64.zip v2ray v2ctl && \
    wget -q -O /usr/local/v2ray/geosite.dat https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat && \
    wget -q -O /usr/local/v2ray/geoip.dat https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat && \
    chmod a+x /usr/local/v2ray/entrypoint.sh

ENTRYPOINT [ "/usr/local/v2ray/entrypoint.sh" ]
CMD ["/usr/bin/supervisord"]
