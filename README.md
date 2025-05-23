# Weather

간단한 커맨드라인 날씨 정보 조회 도구입니다.

## 기능

- 도시 이름을 입력받아 현재 날씨 정보를 출력합니다.
- 외부 API를 통해 실시간 날씨 데이터를 조회합니다.

## 사용법

터미널에서 다음과 같이 실행할 수 있습니다:

```sh
./weather
```

erlang vm이 필요합니다.

### 출력 결과

```
======================= Weather Station ========================
location    : Albuquerque, Albuquerque International Airport, NM
weather     : Fair
station_id  : KABQ
temperature : 61.0 F (16.1 C)
wind        : North at 6.9 MPH (6 KT)
================================================================
```

## 테스트

다음 명령어로 테스트를 실행할 수 있습니다:

```sh
mix test
```

## 문서

[ExDoc](https://github.com/elixir-lang/ex_doc)으로 문서를 생성할 수 있습니다.
