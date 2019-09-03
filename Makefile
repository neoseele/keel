release=test

test:
	@helm template fortio \
	--name ${release} \
	--set customTLS.enabled=true \
	--set persistence.enabled=true \
	--set service.enabled=true \
	--set service.type=NodePort \
	--set service.ilb.enabled=false \
	--set service.headless.enabled=false \
	--set service.http2.enabled=true \
	--set ingress.enabled=true \
	--set ingress.tls.enabled=true \
	--set ingress.nginx.enabled=false \
	--set ingress.iap.enabled=true \
	--set nodeAffinity='' \
	--set podAffinity='' \
	--set podAntiAffinity='' \
	| sed 's/RELEASE/${release}/g'

clean:
	@helm template fortio \
	--name ${release} \
	--set customTLS.enabled=true \
	--set persistence.enabled=true \
	--set service.enabled=true \
	--set ingress.enabled=true \
	--set ingress.nginx=true \
	| sed 's/RELEASE/${release}/g' \
	| kubectl delete -f -
