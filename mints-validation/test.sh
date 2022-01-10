res=$(curl -s http://13.86.37.213:8181/featureTest/validateFeatureFiles | jq '. | {result}')
ans=`echo $res| jq -r '.result'`
if [ $ans = "SUCCESS" ]
then
  echo "John is here !!!"
else
  echo  "failed"
fi

