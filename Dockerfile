# First stage: testing
FROM alpine:3.17 as tester

WORKDIR /src

COPY ./requirements.txt /src/requirements.txt

RUN apk add python3 \
    && apk add py3-pip \
    && pip install -r /src/requirements.txt --ignore-installed packaging

COPY . /src

CMD ["py.test", "--cov-report", "xml:coverage.xml", "--cov=.", "--junitxml=result.xml"]

# Second stage: app deployment
FROM alpine:3.17

WORKDIR /src

COPY --from=tester /src /src

EXPOSE 8000

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
