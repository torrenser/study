# Flannel -> Cilium CNI 마이그레이션

study/kubernetes/auto-setting 으로 구축된 시스템을 기준으로 설명합니다.

cilium 시스템 필요 요구 사항들을 점검하고, flannel 을 삭제 후 cilium 을 설치합니다.

- 리눅스 커널 CONFIG 구성 점검
- flannel helm 삭제 및 나머지 kubernetes 구성 요소 삭제
- flannel 이 추가 구성한 인터페이스 삭제
- kube-proxy 삭제 및 iptables 룰 정리

## 구성 요소
| 파일 이름 | 용도 |
| --- | --- |
| check_cilium_system_requirements.yml | cilium 시스템 필요 구성 요소 파악 |
| migration.sh | flannel -> cilium 마이그레이션 sh 파일 |

## 참고
[1] cilium 시스템 요구사항 : https://docs.cilium.io/en/stable/operations/system_requirements/

모든 내용들은 Cilium 가시다 스터디 후 공부한 내용을 정리하였습니다. 스터디를 진행해주신 가시다님에게 감사의 말씀 드립니다.