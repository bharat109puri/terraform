# Services

This workspace manages some service-related components which are inconvenient to manage in "satellite" workspaces.

ECR repositories are a good example as managing them per-service would allow temporary skew between ECR settings.
Central management also minimise accidental deletion of the repositories, which would have wide-spread implications.
