#!/bin/sh
repo1=$(kubectl get service repo1-ibm-mq --output=jsonpath='{.status.loadBalancer.ingress[0].ip}')
repo2=$(kubectl get service repo2-ibm-mq --output=jsonpath='{.status.loadBalancer.ingress[0].ip}')
#repo1:
echo "alter QMGR CHLAUTH(DISABLED) CONNAUTH(' ')" | kubectl exec repo1-ibm-mq-0 -i -- /usr/bin/runmqsc
echo "alter qmgr CONNAUTH(' ')" | kubectl exec repo1-ibm-mq-0 -i -- /usr/bin/runmqsc
echo "define channel('SVRCONN') CHLTYPE(SVRCONN)" | kubectl exec repo1-ibm-mq-0 -i -- /usr/bin/runmqsc
echo "DEFINE QL(Q1) DEFPSIST(YES)" | kubectl exec repo1-ibm-mq-0 -i -- /usr/bin/runmqsc
echo "alter channel('SVRCONN') CHLTYPE(SVRCONN) SSLCAUTH(OPTIONAL)" | kubectl exec repo1-ibm-mq-0 -i -- /usr/bin/runmqsc
kubectl exec repo1-ibm-mq-0 -i -t -- setmqaut -m repo1 -t q -n Q1 -p app +all

echo "ALTER QMGR REPOS(MQCLUSTER)" | kubectl exec repo1-ibm-mq-0 -i -- /usr/bin/runmqsc
echo "DEFINE CHANNEL('TO.repo1') CHLTYPE(CLUSRCVR) CLUSTER('MQCLUSTER') CONNAME('$repo1') TRPTYPE(TCP)" | kubectl exec repo1-ibm-mq-0 -i -- /usr/bin/runmqsc
echo "DEFINE CHANNEL('TO.repo2') CHLTYPE(CLUSSDR) CLUSTER('MQCLUSTER') CONNAME('$repo2') TRPTYPE(TCP)" | kubectl exec repo1-ibm-mq-0 -i -- /usr/bin/runmqsc
kubectl exec repo1-ibm-mq-0 -i -t -- rm -rf /var/mqm/qmgrs/repo1/qm.ini
kubectl cp ./repo1/qm.ini default/repo1-ibm-mq-0:/var/mqm/qmgrs/repo1/
kubectl exec repo1-ibm-mq-0 -it -- endmqm -r repo1

#repo2:
echo "alter QMGR CHLAUTH(DISABLED) CONNAUTH(' ')" | kubectl exec repo2-ibm-mq-0 -i -- /usr/bin/runmqsc
echo "alter qmgr CONNAUTH(' ')" | kubectl exec repo2-ibm-mq-0 -i -- /usr/bin/runmqsc
echo "define channel('SVRCONN') CHLTYPE(SVRCONN)" | kubectl exec repo2-ibm-mq-0 -i -- /usr/bin/runmqsc
echo "DEFINE QL(Q1) DEFPSIST(YES)" | kubectl exec repo2-ibm-mq-0 -i -- /usr/bin/runmqsc
echo "alter channel('SVRCONN') CHLTYPE(SVRCONN) SSLCAUTH(OPTIONAL)" | kubectl exec repo2-ibm-mq-0 -i -- /usr/bin/runmqsc
kubectl exec repo2-ibm-mq-0 -i -t -- setmqaut -m repo2 -t q -n Q1 -p app +all

echo "ALTER QMGR REPOS(MQCLUSTER)" | kubectl exec repo2-ibm-mq-0 -i -- /usr/bin/runmqsc
echo "DEFINE CHANNEL('TO.repo2') CHLTYPE(CLUSRCVR) CLUSTER('MQCLUSTER') CONNAME('$repo2') TRPTYPE(TCP)" | kubectl exec repo2-ibm-mq-0 -i -- /usr/bin/runmqsc
echo "DEFINE CHANNEL('TO.repo1') CHLTYPE(CLUSSDR) CLUSTER('MQCLUSTER') CONNAME('$repo1') TRPTYPE(TCP)" | kubectl exec repo2-ibm-mq-0 -i -- /usr/bin/runmqsc
kubectl exec repo2-ibm-mq-0 -i -t -- rm -rf /var/mqm/qmgrs/repo2/qm.ini
kubectl cp ./repo2/qm.ini default/repo2-ibm-mq-0:/var/mqm/qmgrs/repo2/
kubectl exec repo2-ibm-mq-0 -it -- endmqm -r repo2

#mqa:
echo "alter QMGR CHLAUTH(DISABLED) CONNAUTH(' ')" | kubectl exec mqa-ibm-mq-0 -i -- /usr/bin/runmqsc
echo "alter qmgr CONNAUTH(' ')" | kubectl exec mqa-ibm-mq-0 -i -- /usr/bin/runmqsc
echo "define channel('SVRCONN') CHLTYPE(SVRCONN)" | kubectl exec mqa-ibm-mq-0 -i -- /usr/bin/runmqsc
echo "DEFINE QL(Q1) DEFPSIST(YES)" | kubectl exec mqa-ibm-mq-0 -i -- /usr/bin/runmqsc
echo "alter channel('SVRCONN') CHLTYPE(SVRCONN) SSLCAUTH(OPTIONAL)" | kubectl exec mqa-ibm-mq-0 -i -- /usr/bin/runmqsc
kubectl exec mqa-ibm-mq-0 -i -t -- setmqaut -m mqa -t q -n Q1 -p app +all

mqa=$(kubectl get service mqa-ibm-mq --output=jsonpath='{.status.loadBalancer.ingress[0].ip}')
echo "ALTER QMGR REPOS(MQCLUSTER)" | kubectl exec mqa-ibm-mq-0 -i -- /usr/bin/runmqsc
echo "DEFINE CHANNEL('TO.mqa') CHLTYPE(CLUSRCVR) CLUSTER('MQCLUSTER') CONNAME('$mqa') TRPTYPE(TCP)" | kubectl exec mqa-ibm-mq-0 -i -- /usr/bin/runmqsc
echo "DEFINE CHANNEL('TO.repo1') CHLTYPE(CLUSSDR) CLUSTER('MQCLUSTER') CONNAME('$repo1') TRPTYPE(TCP)" | kubectl exec mqa-ibm-mq-0 -i -- /usr/bin/runmqsc
kubectl exec mqa-ibm-mq-0 -i -t -- rm -rf /var/mqm/qmgrs/mqa/qm.ini
kubectl cp ./mqa/qm.ini default/mqa-ibm-mq-0:/var/mqm/qmgrs/mqa/
kubectl exec mqa-ibm-mq-0 -it -- endmqm -r mqa

#mqb:
echo "alter QMGR CHLAUTH(DISABLED) CONNAUTH(' ')" | kubectl exec mqb-ibm-mq-0 -i -- /usr/bin/runmqsc
echo "alter qmgr CONNAUTH(' ')" | kubectl exec mqb-ibm-mq-0 -i -- /usr/bin/runmqsc
echo "define channel('SVRCONN') CHLTYPE(SVRCONN)" | kubectl exec mqb-ibm-mq-0 -i -- /usr/bin/runmqsc
echo "DEFINE QL(Q1) DEFPSIST(YES)" | kubectl exec mqb-ibm-mq-0 -i -- /usr/bin/runmqsc
echo "alter channel('SVRCONN') CHLTYPE(SVRCONN) SSLCAUTH(OPTIONAL)" | kubectl exec mqb-ibm-mq-0 -i -- /usr/bin/runmqsc
kubectl exec mqb-ibm-mq-0 -i -t -- setmqaut -m mqb -t q -n Q1 -p app +all

mqb=$(kubectl get service mqb-ibm-mq --output=jsonpath='{.status.loadBalancer.ingress[0].ip}')
echo "ALTER QMGR REPOS(MQCLUSTER)" | kubectl exec mqb-ibm-mq-0 -i -- /usr/bin/runmqsc
echo "DEFINE CHANNEL('TO.mqb') CHLTYPE(CLUSRCVR) CLUSTER('MQCLUSTER') CONNAME('$mqb') TRPTYPE(TCP)" | kubectl exec mqb-ibm-mq-0 -i -- /usr/bin/runmqsc
echo "DEFINE CHANNEL('TO.repo1') CHLTYPE(CLUSSDR) CLUSTER('MQCLUSTER') CONNAME('$repo1') TRPTYPE(TCP)" | kubectl exec mqb-ibm-mq-0 -i -- /usr/bin/runmqsc
kubectl exec mqb-ibm-mq-0 -i -t -- rm -rf /var/mqm/qmgrs/mqb/qm.ini
kubectl cp ./mqb/qm.ini default/mqb-ibm-mq-0:/var/mqm/qmgrs/mqb/
kubectl exec mqb-ibm-mq-0 -it -- endmqm -r mqb

#mqc:
echo "alter QMGR CHLAUTH(DISABLED) CONNAUTH(' ')" | kubectl exec mqc-ibm-mq-0 -i -- /usr/bin/runmqsc
echo "alter qmgr CONNAUTH(' ')" | kubectl exec mqc-ibm-mq-0 -i -- /usr/bin/runmqsc
echo "define channel('SVRCONN') CHLTYPE(SVRCONN)" | kubectl exec mqc-ibm-mq-0 -i -- /usr/bin/runmqsc
echo "DEFINE QL(Q1) DEFPSIST(YES)" | kubectl exec mqc-ibm-mq-0 -i -- /usr/bin/runmqsc
echo "alter channel('SVRCONN') CHLTYPE(SVRCONN) SSLCAUTH(OPTIONAL)" | kubectl exec mqc-ibm-mq-0 -i -- /usr/bin/runmqsc
kubectl exec mqc-ibm-mq-0 -i -t -- setmqaut -m mqc -t q -n Q1 -p app +all

mqc=$(kubectl get service mqc-ibm-mq --output=jsonpath='{.status.loadBalancer.ingress[0].ip}')
echo "ALTER QMGR REPOS(MQCLUSTER)" | kubectl exec mqc-ibm-mq-0 -i -- /usr/bin/runmqsc
echo "DEFINE CHANNEL('TO.mqc') CHLTYPE(CLUSRCVR) CLUSTER('MQCLUSTER') CONNAME('$mqc') TRPTYPE(TCP)" | kubectl exec mqc-ibm-mq-0 -i -- /usr/bin/runmqsc
echo "DEFINE CHANNEL('TO.repo1') CHLTYPE(CLUSSDR) CLUSTER('MQCLUSTER') CONNAME('$repo1') TRPTYPE(TCP)" | kubectl exec mqc-ibm-mq-0 -i -- /usr/bin/runmqsc
kubectl exec mqc-ibm-mq-0 -i -t -- rm -rf /var/mqm/qmgrs/mqc/qm.ini
kubectl cp ./mqc/qm.ini default/mqc-ibm-mq-0:/var/mqm/qmgrs/mqc/
kubectl exec mqc-ibm-mq-0 -it -- endmqm -r mqc
