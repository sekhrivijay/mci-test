FROM python:3.9-slim
LABEL maintainer="Vijay"


RUN curl -sSL https://sdk.cloud.google.com | bash
ENV PATH $PATH:/root/google-cloud-sdk/bin
RUN pip3 install --no-cache pyOpenSSL
RUN pip3 install --upgrade google-cloud-pubsub
RUN pip3 install --upgrade google-cloud-error-reporting
RUN pip3 install --upgrade google-cloud-secret-manager
RUN pip3 install --upgrade google-cloud-logging
RUN pip3 install Flask gunicorn
RUN apt-get update && apt-get install -y curl dnsutils
ENV PYTHONUNBUFFERED True



LABEL maintainer="Vijay Sekhri"

ENV APP_HOME /app
WORKDIR $APP_HOME
COPY . ./

ENV PATH /:$PATH
RUN chmod +x $APP_HOME/entrypoint.sh
RUN ls -lrth /app
ENTRYPOINT ["/app/entrypoint.sh"]
