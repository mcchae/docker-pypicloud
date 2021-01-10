# 목적

[pypicloud](https://pypicloud.readthedocs.io/en/latest/) 는 로컬 파일시스템 뿐만 아니라 S3나 GCS 등에 파이썬 모듈을 저장하고 빨리 찾을 수 있도록 색인되어 있으며, 무엇 보다도 간편한 웹UI가 있어 사용하기 쉽게 되어 있습니다. 이와 같은 pypicloud를 간편하게 docker-compose로 이용할 수 있게 제공합니다.

> Note: [stevearc/pypicloud-docker](https://github.com/stevearc/pypicloud-docker) 의 내용을 기본으로 작업

# 사용방법

## 파일 복사
다음의 세가지 파일을 운영할 폴더에 복사합니다.
* [docker-compose.yaml](https://github.com/mcchae/docker-pypicloud/blob/main/docker-compose.yaml): docker-compose 용 설정 파일
* [start.sh](https://github.com/mcchae/docker-pypicloud/blob/main/start.sh): 시작 쉘 스크립트 파일
* [stop.sh](https://github.com/mcchae/docker-pypicloud/blob/main/stop.sh): 종료 쉘 스크립트 파일

## 시작 및 종료

### 시작

```sh
./start.sh
```
위와 같이 실행하면 현재 폴더에 `datadir` 이라는 MySQL용 데이터 폴더와 `packages`라는 파이썬 모듈 폴더가 생성됩니다.

> * MacOS에서는 바로 동일한 사용자로 해당 폴더를 만들어 사용해도 됩니다
> * 그러나 Photon OS와 같은 경우는 특정 사용자에 맞게 해당 `UID/GID`를 변경해야 하므로 이에 대한 스크립트를 start.sh 에 기술하였습니다.

실행하면 `docker-compose up` 명령에 `-d`로 수행되어 detach 되어 있고 이어 `docker-compose logs -f` 명령으로 계속하여 화면에는 로그가 보이도록 되어 있습니다만, `Control+C`로 종료하여 해당 터미널에서 다른 작업을 할 수 있습니다. 

### 종료
```sh
./stop.sh
```
위와 같이 실행하여 돌고 있는 mysql과 pypicloud 컨테이너를 종료시킵니다.

### 작업내용

* `config-mysql.ini` 의 내용을 /etc/pypicloud/config.ini 에 넣음
  * 디폴트로 로그인을 하지 않아도 패키지를 읽을 수 있도록 다음 내용 추가
    * `pypi.default_read = everyone`
  * uwsgi 설정에서 디폴트 프로세스를 20개 띄우는데 이를 절반으로 줄임
    * `processes = 4` <= 20
    * `reload-mercy = 3` <= 15
    * `worker-reload-mercy = 3` <= 15
  > 만약 위의 내용을 다른 설정으로 실행시키려면, 다음과 같이 pypicloud의 볼륨 마운트에 추가하면 됨
  
  ```yaml
      volumes:
      - ./config-mysql.ini:/etc/pypicloud/config.ini:ro
  ```

## 문의사항
기타 문의사항 등은 mcchae@gmail.com 으로 문의 주십시오
