FROM python:3.7

ENV FLASK_RUN_HOST=0.0.0.0
ENV FLASK_RUN_PORT=3000



RUN mkdir -p /root/.config/youtube-dl
RUN echo "--cookies-from-browser=firefox" > /root/.config/youtube-dl/config

### you can add netrc to autologin for yt-dlp sites 

#ADD netrc /etc/.netrc
#ADD netrc /etc/netrc

#RUN chmod 600 /etc/netrc
#ADD netrc /root/.netrc
#RUN chmod a-rwx,u+rw /root/.netrc
#RUN chmod a-rwx,u+rw /etc/.netrc

### extract cookies from browser is activ, so you can add your firefox profile in this dir & rebuild the container 

#ADD firefox /root/.mozilla/firefox

RUN mkdir -p /app/not_downloaded/
RUN mkdir -p /app/static 2/
RUN mkdir -p /app/content/

WORKDIR /app


ADD templates /app/templates

ADD requirements.txt /app/requirements.txt

RUN pip3 install -r requirements.txt

RUN pip3 install git+https://github.com/yt-dlp/yt-dlp


RUN rm -fR /root/.pip
RUN rm -fR /var/cache 
RUN rm -fR /root/.cache


ADD yt-interval.py /app/app.py
ADD ParseInput.py /app/ParseInput.py
ADD ffmpeg /usr/bin/ffmpeg


ENTRYPOINT ["python3","-mflask","run","--host=0.0.0.0"]

LABEL maintainer="Daniel Biesecke <dbiesecke@gmail.com>"
