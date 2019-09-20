// +build kubeall helm

// **NOTE**: we have build tags to differentiate kubernetes tests from non-kubernetes tests, and further differentiate helm
// tests. This is done because minikube is heavy and can interfere with docker related tests in terratest. Similarly, helm
// can overload the minikube system and thus interfere with the other kubernetes tests. Specifically, many of the tests
// start to fail with `connection refused` errors from `minikube`. To avoid overloading the system, we run the kubernetes
// tests and helm tests separately from the others. This may not be necessary if you have a sufficiently powerful machine.
// We recommend at least 4 cores and 16GB of RAM if you want to run all the tests together.

package test

import (
	"path/filepath"
	"testing"

	"github.com/stretchr/testify/require"
	appsv1 "k8s.io/api/apps/v1"

	"github.com/gruntwork-io/terratest/modules/helm"
)

// This file contains examples of how to use terratest to test helm chart template logic by rendering the templates
// using `helm template`, and then reading in the rendered templates.
// There are two tests:
// - TestHelmBasicExampleTemplateRenderedDeployment: An example of how to read in the rendered object and check the
//   computed values.
// - TestHelmBasicExampleTemplateRequiredTemplateArgs: An example of how to check that the required args are indeed
//   required for the template to render.

// An example of how to verify the rendered template object of a Helm Chart given various inputs.
func TestHelmBasicExampleTemplateRenderedDeployment(t *testing.T) {
	t.Parallel()

	// Path to the helm chart we will test
	helmChartPath, err := filepath.Abs("../examples/fortio")
	require.NoError(t, err)

	// Since we aren't deploying any resources, there is no need to setup kubectl authentication, helm home, or
	// namespaces

	// Setup the args.
	options := &helm.Options{
		SetValues: map[string]string{
			"customTLS.enabled": "true",
			"persistence.enabled":  "true",
			"service.enabled": "true",
			"service.type": "NodePort",
			"service.ilb.enabled": "false",
			"service.headless.enabled": "false",
			"service.http2.enabled": "true",
			"ingress.enabled": "true",
			"ingress.tls.enabled": "true",
			"ingress.nginx.enabled": "false",
			"ingress.iap.enabled": "true",
		},
	}

	// Run RenderTemplate to render the template and capture the output. Note that we use the version without `E`, since
	// we want to assert that the template renders without any errors.
	// Additionally, although we know there is only one yaml file in the template, we deliberately path a templateFiles
	// arg to demonstrate how to select individual templates to render.
	output := helm.RenderTemplate(t, options, helmChartPath, []string{"templates/deployment.yaml"})

	// Now we use kubernetes/client-go library to render the template output into the Deployment struct. This will
	// ensure the Deployment resource is rendered correctly.
	var deployment appsv1.Deployment
	helm.UnmarshalK8SYaml(t, output, &deployment)

	// Finally, we verify the deployment pod template spec is set to the expected container image value
	expectedContainerImage := "gcr.io/nmiu-play/fortio:latest"
	deploymentContainers := deployment.Spec.Template.Spec.Containers
	require.Equal(t, len(deploymentContainers), 1)
	require.Equal(t, deploymentContainers[0].Image, expectedContainerImage)
}