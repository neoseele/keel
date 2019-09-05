yaml := "`helm template fortio \
	--name ${RELEASE} \
	--set customTLS.enabled=true \
	--set persistence.enabled=true \
	--set service.enabled=true \
	--set service.type=NodePort \
	--set service.ilb.enabled=false \
	--set service.headless.enabled=false \
	--set service.http2.enabled=true \
	--set ingress.enabled=true \
	--set ingress.class='gce' \
	--set ingress.tls.enabled=true \
	--set ingress.iap.enabled=true \
	--set defaultIAP.clientId=${IAP_CLIENT_ID} \
	--set defaultIAP.clientSecret=${IAP_CLIENT_SECRET} \
	--set nginx-ingress.enabled=false \
	--set nodeAffinity='' \
	--set podAffinity='' \
	--set podAntiAffinity.type=hard \
	| sed 's/RELEASE/${RELEASE}/g'`"

dry-run:
	@echo ${yaml}

apply:
	@echo ${yaml} | kubectl apply -f -

clean:
	@echo ${yaml} | kubectl delete -f -
