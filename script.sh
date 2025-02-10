#!/bin/bash


# AWS Resource Tracking Script
# Author: Guptha
# Date: 2024-02-10
# Description: This script collects AWS resource details (EC2, S3, IAM Users) and generates a report.

# Define output directory and file
OUTPUT_DIR="reports"
TIMESTAMP=$(date +'%Y-%m-%d_%H-%M-%S')
OUTPUT_FILE="$OUTPUT_DIR/aws_resources_report_$TIMESTAMP.txt"

# Ensure the reports directory exists
mkdir -p "$OUTPUT_DIR"

# Function to fetch EC2 Instances
get_ec2_instances() {
    echo "Fetching EC2 Instances..."
    echo -e "\nEC2 Instances:" >> "$OUTPUT_FILE"
    aws ec2 describe-instances --query "Reservations[*].Instances[*].{ID:InstanceId, State:State.Name, Type:InstanceType, Region:Placement.AvailabilityZone}" --output table >> "$OUTPUT_FILE" 2>/dev/null
    echo "---------------------------------" >> "$OUTPUT_FILE"
}


# Function to fetch S3 Buckets
get_s3_buckets() {
    echo "Fetching S3 Buckets..."
    echo -e "\nS3 Buckets:" >> "$OUTPUT_FILE"
    aws s3 ls >> "$OUTPUT_FILE" 2>/dev/null
    echo "---------------------------------" >> "$OUTPUT_FILE"
}

# Function to fetch IAM Users
get_iam_users() {
    echo "Fetching IAM Users..."
    echo -e "\nIAM Users:" >> "$OUTPUT_FILE"
    aws iam list-users --query "Users[*].{User:UserName, Created:CreateDate}" --output table >> "$OUTPUT_FILE" 2>/dev/null
    echo "---------------------------------" >> "$OUTPUT_FILE"
}

# Function to fetch Running EC2 Instances Only
get_running_ec2() {
    echo "Fetching Running EC2 Instances..."
    echo -e "\nRunning EC2 Instances:" >> "$OUTPUT_FILE"
    aws ec2 describe-instances --filters "Name=instance-state-name,Values=running" --query "Reservations[*].Instances[*].{ID:InstanceId, Type:InstanceType, Region:Placement.AvailabilityZone}" --output table >> "$OUTPUT_FILE" 2>/dev/null
    echo "---------------------------------" >> "$OUTPUT_FILE"
}

# Function to fetch Security Groups
get_security_groups() {
    echo "Fetching Security Groups..."
    echo -e "\nSecurity Groups:" >> "$OUTPUT_FILE"
    aws ec2 describe-security-groups --query "SecurityGroups[*].{Name:GroupName, ID:GroupId, VPC:VpcId}" --output table >> "$OUTPUT_FILE" 2>/dev/null
    echo "---------------------------------" >> "$OUTPUT_FILE"
}

# Function to fetch IAM Roles
get_iam_roles() {
    echo "Fetching IAM Roles..."
    echo -e "\nIAM Roles:" >> "$OUTPUT_FILE"
    aws iam list-roles --query "Roles[*].{RoleName:RoleName, Created:CreateDate}" --output table >> "$OUTPUT_FILE" 2>/dev/null
    echo "---------------------------------" >> "$OUTPUT_FILE"
}

# Function to fetch Unused EBS Volumes
get_unused_ebs_volumes() {
    echo "Fetching Unused EBS Volumes..."
    echo -e "\nUnused EBS Volumes:" >> "$OUTPUT_FILE"
    aws ec2 describe-volumes --filters "Name=status,Values=available" --query "Volumes[*].{ID:VolumeId, Size:Size, AZ:AvailabilityZone}" --output table >> "$OUTPUT_FILE" 2>/dev/null
    echo "---------------------------------" >> "$OUTPUT_FILE"
}

# Function to fetch Lambda Functions
get_lambda_functions() {
    echo "Fetching Lambda Functions..."
    echo -e "\nLambda Functions:" >> "$OUTPUT_FILE"
    aws lambda list-functions --query "Functions[*].{FunctionName:FunctionName, Runtime:Runtime, LastModified:LastModified}" --output table >> "$OUTPUT_FILE" 2>/dev/null
    echo "---------------------------------" >> "$OUTPUT_FILE"
}

# Generate report
echo "==================================================" > "$OUTPUT_FILE"
echo "AWS Resource Report - Generated on: $(date)" >> "$OUTPUT_FILE"
echo "==================================================" >> "$OUTPUT_FILE"

# Call functions
get_ec2_instances
get_running_ec2
get_s3_buckets
get_iam_users
get_security_groups
get_iam_roles
get_unused_ebs_volumes
get_lambda_functions

echo "✅ Report generated successfully: $OUTPUT_FILE"
