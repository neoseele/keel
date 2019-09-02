release=test

test:
	@helm template fortio \
	--name ${release} \
	--set tls.enabled=true \
	--set pvc.enabled=true \
	--set data.enabled=true \
	--set service.enabled=true \
	--set service.type=ClusterIP \
	--set ingress.enabled=true \
	--set ingress.nginx=true \
	--set nodeAffinity='' \
	--set podAffinity='' \
	--set podAntiAffinity='' \
	| sed 's/RELEASE/${release}/g'

clean:
	@helm template fortio \
	--name ${release} \
	--set tls.enabled=true \
	--set pvc.enabled=true \
	--set data.enabled=true \
	--set service.enabled=true \
	--set ingress.enabled=true \
	--set ingress.nginx=true \
	| sed 's/RELEASE/${release}/g' \
	| kubectl delete -f -