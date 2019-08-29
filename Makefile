deploy:
	helm template fortio --name test \
	--set volumn.enabled=true
	# --set service.type=NodePort \
	# --set ingress.enabled=true \
	# --set service.http2.enabled=true \
	| kubectl apply -f -

clean:
	helm template fortio --name test \
	--set service.type=NodePort \
	--set ingress.enabled=true \
	--set service.http2.enabled=true \
	| kubectl delete -f -