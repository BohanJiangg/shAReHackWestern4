// WARNING: DO NOT EDIT. This file is Auto-Generated by AWS Mobile Hub. It will be overwritten.

// Copyright 2017 Amazon.com, Inc. or its affiliates (Amazon). All Rights Reserved.
// Code generated by AWS Mobile Hub. Amazon gives unlimited permission to
// copy, distribute and modify it.

// AWS Mobile Hub Project Constants
const aws_cloud_logic = 'enable';
const aws_cloud_logic_custom = '[{"id":"ly62uttshe","name":"ReactSample","description":"","endpoint":"https://ly62uttshe.execute-api.us-east-1.amazonaws.com/Development","region":"us-east-1","paths":["/items","/items/123"]}]';
const aws_cognito_identity_pool_id = 'us-east-1:456a4c88-7f96-4783-a82e-a97f2c9dc22a';
const aws_cognito_region = 'us-east-1';
const aws_content_delivery = 'enable';
const aws_content_delivery_bucket = 'share-hosting-mobilehub-1774715290';
const aws_content_delivery_bucket_region = 'us-east-1';
const aws_content_delivery_cloudfront = 'enable';
const aws_content_delivery_cloudfront_domain = 'doz4p95bi6nnq.cloudfront.net';
const aws_dynamodb = 'enable';
const aws_dynamodb_all_tables_region = 'us-east-1';
const aws_dynamodb_table_schemas = '[{"tableName":"share-mobilehub-1774715290-bbq_orders","attributes":[{"name":"id","type":"S"}],"indexes":[],"region":"us-east-1","hashKey":"id"},{"tableName":"share-mobilehub-1774715290-locations","attributes":[{"name":"id","type":"S"},{"name":"latitude","type":"N"},{"name":"longitude","type":"N"}],"indexes":[],"region":"us-east-1","hashKey":"id"},{"tableName":"share-mobilehub-1774715290-bbq_restaurants","attributes":[{"name":"id","type":"S"}],"indexes":[],"region":"us-east-1","hashKey":"id"},{"tableName":"share-mobilehub-1774715290-bbq_menu_item","attributes":[{"name":"restaurant_id","type":"S"},{"name":"id","type":"S"}],"indexes":[],"region":"us-east-1","hashKey":"restaurant_id","rangeKey":"id"}]';
const aws_mandatory_sign_in = 'enable';
const aws_project_id = '8b6b6cd3-86db-481c-b359-83398ca30aee';
const aws_project_name = 'shARe';
const aws_project_region = 'us-east-1';
const aws_resource_bucket_name = 'share-deployments-mobilehub-1774715290';
const aws_resource_name_prefix = 'share-mobilehub-1774715290';
const aws_sign_in_enabled = 'enable';
const aws_user_pools = 'enable';
const aws_user_pools_id = 'us-east-1_gpSM0lZXS';
const aws_user_pools_mfa_type = 'ON';
const aws_user_pools_web_client_id = '2g951ckch91sljg58t1r4ij9n6';

AWS.config.region = aws_project_region;
AWS.config.credentials = new AWS.CognitoIdentityCredentials({
    IdentityPoolId: aws_cognito_identity_pool_id
  }, {
    region: aws_cognito_region
});
AWS.config.update({customUserAgent: 'MobileHub v0.1'});
