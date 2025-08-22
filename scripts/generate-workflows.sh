#!/bin/bash

# Generate individual workspace workflows
generate_workspace_workflow() {
    local workspace_name="$1"
    local workspace_path="$2"
    local filename=".github/workflows/terraform-${workspace_name}-execution.yml"
    
    cat > "$filename" << EOF
name: Terraform ${workspace_name}
run-name: Terraform ${workspace_name} - \${{ github.actor }} - \${{ github.sha }}

on:
  push:
    branches: [main]
    paths: 
      - '${workspace_path}/**'
      - '.github/workflows/terraform-${workspace_name}-execution.yml'
  pull_request:
    branches: [main]
    paths: 
      - '${workspace_path}/**'
      - '.github/workflows/terraform-${workspace_name}-execution.yml'
  workflow_dispatch:

concurrency:
  group: terraform-${workspace_name}-\${{ github.ref }}
  cancel-in-progress: false

permissions:
  id-token: write
  contents: read
  pull-requests: write

jobs:
  get-runner-credentials:
    runs-on: ubuntu-latest
    timeout-minutes: 10
    outputs:
      runner-access-key: \${{ steps.get-creds.outputs.access-key }}
      runner-secret-key: \${{ steps.get-creds.outputs.secret-key }}
    steps:
      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: arn:aws:iam::\${{ secrets.PROD_AWS_ACCOUNT_NUMBER }}:role/GitHubActions-MultiRepo
          aws-region: us-east-2

      - name: Get runner credentials from AWS Secrets
        id: get-creds
        run: |
          set +x
          CREDS=\$(aws secretsmanager get-secret-value --secret-id production/heezy/github_runner/aws_credentials --query SecretString --output text)
          ACCESS_KEY=\$(echo \$CREDS | jq -r '.AWS_ACCESS_KEY_ID')
          SECRET_KEY=\$(echo \$CREDS | jq -r '.AWS_SECRET_ACCESS_KEY')
          echo "access-key=\$ACCESS_KEY" >> \$GITHUB_OUTPUT
          echo "secret-key=\$SECRET_KEY" >> \$GITHUB_OUTPUT

  terraform-plan:
    needs: [get-runner-credentials]
    runs-on: self-hosted
    timeout-minutes: 180
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Terraform Init and Plan
        working-directory: ${workspace_path}
        env:
          AWS_ACCESS_KEY_ID: \${{ needs.get-runner-credentials.outputs.runner-access-key }}
          AWS_SECRET_ACCESS_KEY: \${{ needs.get-runner-credentials.outputs.runner-secret-key }}
        run: |
          set +x
          TERRAFORM_CREDS=\$(aws sts assume-role --role-arn arn:aws:iam::\${{ secrets.PROD_AWS_ACCOUNT_NUMBER }}:role/productionATerraformStateBackend --role-session-name terraform-session)
          
          export AWS_ACCESS_KEY_ID=\$(echo \$TERRAFORM_CREDS | jq -r '.Credentials.AccessKeyId')
          export AWS_SECRET_ACCESS_KEY=\$(echo \$TERRAFORM_CREDS | jq -r '.Credentials.SecretAccessKey')
          export AWS_SESSION_TOKEN=\$(echo \$TERRAFORM_CREDS | jq -r '.Credentials.SessionToken')
          
          echo "::add-mask::\$AWS_ACCESS_KEY_ID"
          echo "::add-mask::\$AWS_SECRET_ACCESS_KEY"
          echo "::add-mask::\$AWS_SESSION_TOKEN"
          
          set -x
          terraform init
          terraform plan -no-color -out=tfplan
          terraform show -no-color tfplan > plan.txt

      - name: Comment Plan on PR
        if: github.event_name == 'pull_request'
        uses: actions/github-script@v7
        with:
          script: |
            const fs = require('fs');
            const plan = fs.readFileSync('${workspace_path}/plan.txt', 'utf8');
            const body = \`## Terraform Plan - ${workspace_name}
            \\\`\\\`\\\`
            \${plan}
            \\\`\\\`\\\`\`;

            github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: body
            });

  terraform-apply:
    if: github.ref == 'refs/heads/main' || github.event_name == 'workflow_dispatch'
    needs: [get-runner-credentials, terraform-plan]
    runs-on: self-hosted
    timeout-minutes: 180
    environment: production
    concurrency:
      group: terraform-deploy-${workspace_name}
      cancel-in-progress: false
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Terraform Init and Apply
        working-directory: ${workspace_path}
        env:
          AWS_ACCESS_KEY_ID: \${{ needs.get-runner-credentials.outputs.runner-access-key }}
          AWS_SECRET_ACCESS_KEY: \${{ needs.get-runner-credentials.outputs.runner-secret-key }}
        run: |
          set +x
          TERRAFORM_CREDS=\$(aws sts assume-role --role-arn arn:aws:iam::\${{ secrets.PROD_AWS_ACCOUNT_NUMBER }}:role/productionATerraformStateBackend --role-session-name terraform-session)
          
          export AWS_ACCESS_KEY_ID=\$(echo \$TERRAFORM_CREDS | jq -r '.Credentials.AccessKeyId')
          export AWS_SECRET_ACCESS_KEY=\$(echo \$TERRAFORM_CREDS | jq -r '.Credentials.SecretAccessKey')
          export AWS_SESSION_TOKEN=\$(echo \$TERRAFORM_CREDS | jq -r '.Credentials.SessionToken')
          
          echo "::add-mask::\$AWS_ACCESS_KEY_ID"
          echo "::add-mask::\$AWS_SECRET_ACCESS_KEY"
          echo "::add-mask::\$AWS_SESSION_TOKEN"
          
          set -x
          terraform init
          terraform plan -no-color -out=tfplan
          terraform apply -auto-approve tfplan

  notify:
    if: always()
    needs: [terraform-apply]
    uses: ./.github/workflows/_discord-notify.yml
    with:
      status: \${{ needs.terraform-apply.result == 'success' && 'success' || 'failure' }}
      workflow-name: Terraform ${workspace_name}
    secrets: inherit
EOF
    
    echo "Generated $filename"
}

# Generate all workspaces workflow
generate_all_workspaces_workflow() {
    local filename=".github/workflows/terraform-all-workspaces.yml"
    
    cat > "$filename" << 'EOF'
name: Terraform All Workspaces
run-name: Terraform All Workspaces - ${{ github.actor }} - ${{ github.sha }}

on:
  workflow_dispatch:

concurrency:
  group: terraform-all-workspaces-${{ github.ref }}
  cancel-in-progress: false

permissions:
  id-token: write
  contents: read
  pull-requests: write

jobs:
  get-runner-credentials:
    runs-on: ubuntu-latest
    timeout-minutes: 10
    outputs:
      runner-access-key: ${{ steps.get-creds.outputs.access-key }}
      runner-secret-key: ${{ steps.get-creds.outputs.secret-key }}
    steps:
      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: arn:aws:iam::${{ secrets.PROD_AWS_ACCOUNT_NUMBER }}:role/GitHubActions-MultiRepo
          aws-region: us-east-2

      - name: Get runner credentials from AWS Secrets
        id: get-creds
        run: |
          set +x
          CREDS=$(aws secretsmanager get-secret-value --secret-id production/heezy/github_runner/aws_credentials --query SecretString --output text)
          ACCESS_KEY=$(echo $CREDS | jq -r '.AWS_ACCESS_KEY_ID')
          SECRET_KEY=$(echo $CREDS | jq -r '.AWS_SECRET_ACCESS_KEY')
          echo "access-key=$ACCESS_KEY" >> $GITHUB_OUTPUT
          echo "secret-key=$SECRET_KEY" >> $GITHUB_OUTPUT

  terraform-all:
    needs: [get-runner-credentials]
    runs-on: self-hosted
    timeout-minutes: 180
    strategy:
      max-parallel: 4
      matrix:
        workspace:
          - { name: "shared-heezy", path: "environments/shared/heezy" }
          - { name: "shared-aws", path: "environments/shared/aws" }
          - { name: "production-heezy", path: "environments/production/heezy" }
          - { name: "production-aws", path: "environments/production/aws" }
          - { name: "dev-heezy", path: "environments/dev/heezy" }
          - { name: "dev-aws", path: "environments/dev/aws" }
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Terraform Init and Apply
        working-directory: ${{ matrix.workspace.path }}
        env:
          AWS_ACCESS_KEY_ID: ${{ needs.get-runner-credentials.outputs.runner-access-key }}
          AWS_SECRET_ACCESS_KEY: ${{ needs.get-runner-credentials.outputs.runner-secret-key }}
        run: |
          set +x
          TERRAFORM_CREDS=$(aws sts assume-role --role-arn arn:aws:iam::${{ secrets.PROD_AWS_ACCOUNT_NUMBER }}:role/productionATerraformStateBackend --role-session-name terraform-session)
          
          export AWS_ACCESS_KEY_ID=$(echo $TERRAFORM_CREDS | jq -r '.Credentials.AccessKeyId')
          export AWS_SECRET_ACCESS_KEY=$(echo $TERRAFORM_CREDS | jq -r '.Credentials.SecretAccessKey')
          export AWS_SESSION_TOKEN=$(echo $TERRAFORM_CREDS | jq -r '.Credentials.SessionToken')
          
          echo "::add-mask::$AWS_ACCESS_KEY_ID"
          echo "::add-mask::$AWS_SECRET_ACCESS_KEY"
          echo "::add-mask::$AWS_SESSION_TOKEN"
          
          set -x
          terraform init
          terraform plan -no-color -out=tfplan
          terraform apply -auto-approve tfplan

  notify:
    if: always()
    needs: [terraform-all]
    uses: ./.github/workflows/_discord-notify.yml
    with:
      status: ${{ needs.terraform-all.result == 'success' && 'success' || 'failure' }}
      workflow-name: Terraform All Workspaces
    secrets: inherit
EOF
    
    echo "Generated $filename"
}

# Main execution
mkdir -p .github/workflows

# Generate individual workflows
generate_workspace_workflow "shared-heezy" "environments/shared/heezy"
generate_workspace_workflow "shared-aws" "environments/shared/aws"
generate_workspace_workflow "production-heezy" "environments/production/heezy"
generate_workspace_workflow "production-aws" "environments/production/aws"
generate_workspace_workflow "dev-heezy" "environments/dev/heezy"
generate_workspace_workflow "dev-aws" "environments/dev/aws"

# Generate all workspaces workflow
generate_all_workspaces_workflow

echo "Total workflows generated: 7"