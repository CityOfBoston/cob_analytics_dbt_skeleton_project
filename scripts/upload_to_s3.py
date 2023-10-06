from datetime import datetime
import logging
import os

import boto3


AWS_DEFAULT_REGION = 'us-east-1'
DEFAULT_LOGGING_FORMAT = '%(asctime)s | %(module)s | %(levelname)-8s | %(pathname)s:%(lineno)s - %(message)s'


def s3_connect_bucket(
    aws_access_key_id, aws_secret_access_key, aws_region=AWS_DEFAULT_REGION,
    bucket_name='default_bucket'):
    """
    # -*- coding: utf-8 -*-
    Module that contains utility functions for AWS.

    Establishes a connection to the S3 instance and specified bucket.

    Parameters
    ----------
    aws_access_key_id : str
        The API key provided by AWS to an AWS service account attached to the S3 instance
    aws_secret_access_key : str
        The secret key provided by AWS to an AWS service account attached to the S3 instance
    aws_region : str
        The AWS region where the bucket is located
    bucket_name : str
        The root bucket of the S3 connection. Defaults to COB root bucket.

    Returns
    -------
    result : S3 Bucket Object
    """
    try:
        session = boto3.Session(aws_access_key_id=aws_access_key_id, aws_secret_access_key=aws_secret_access_key, region_name=aws_region)
        s3_resource = session.resource('s3')
        my_bucket = s3_resource.Bucket(name=bucket_name)
        if my_bucket.creation_date:
            logging.info(f"The bucket {bucket_name} exists with creation date {my_bucket.creation_date}")
        else:
            logging.info(f"The bucket {bucket_name} does not appear to exist")
        return my_bucket
        
    except Exception as err:
        logging.info(f'Could not connect to S3 bucket {bucket_name}:\n{err}')
        raise err


def create_bucket_file_name(file_name: str, folder_path: str, add_timestamp: bool = False, file_type: str = 'csv'):
    """Create the full file name used in the S3 bucket, including the file path

    Parameters
    ----------
    file_name : str
        The name of the file itself
    folder_path : str
        The path to where the file should be placed within the S3 bucket. Should not start with a "/"
    add_timestamp : bool
        Whether or not to add the current timestamp to the filename. Defaults to False.

    Returns
    -------
    full file name/path : str
    """
    if (len(folder_path) >= 1) and (not folder_path.endswith('/')):
        folder_path += '/'
    if file_type.startswith('.'):
        file_type = file_type[1:]
    assert not folder_path.startswith("/"), "Folder path should not start with a '/', just the folder name"
    if file_name.endswith(file_type):
        slice_index = len(file_type) + 1
        file_name = file_name[:-(slice_index)]
    if add_timestamp:
        current_datetime = datetime.now()
        str_now = current_datetime.strftime('%Y-%m-%dT%H:%M:%S')
        return f"{folder_path}{file_name}_{str_now}.{file_type}"
    else:
        return f"{folder_path}{file_name}.{file_type}"


def s3_upload(
    bucket, file_list, path_in_bucket, server_side_encryption,
    storage_class, file_type='csv'):
    """Uploads CSV file(s) to S3 bucket.
    Server side encryption (common on S3) is set to default to AWS KMS keys
    (aws:kms), but can also be set to S3-Managed Keys (AES256)
    More details at https://docs.aws.amazon.com/AmazonS3/latest/userguide/serv-side-encryption.html
    and at https://boto3.amazonaws.com/v1/documentation/api/1.9.46/reference/services/s3.html#S3.Bucket.put_object.
    Storage class is set to 'STANDARD_IA' (infrequently accessed), but can also
    be set to others (described at https://aws.amazon.com/s3/storage-classes/).

    Parameters
    ----------
    bucket : boto3.resource.Bucket object
        Instance of a Bucket object, returned by s3_connect_bucket()
    file_list : list
        List of files within the SFTP folder to upload to Civis cluster
    path_in_bucket : str
        The path to where the file should be placed within the S3 bucket. Should not start with a "/"
    server_side_encryption : str (default 'aws:kms')
        Type of AWS server side encryption used, if any
    storage_class : str
        Desired storage class for file/object once it's on S3

    Returns
    -------
    civis_file_ids : list of file_ids on Civis cluster
    """
    if server_side_encryption or storage_class:
        extra_args = {}
        if server_side_encryption:
            extra_args["ServerSideEncryption"] = server_side_encryption
        if storage_class:
            extra_args["StorageClass"] = storage_class
    else:
        extra_args = None

    for fn in file_list:
        bucket_file_name = create_bucket_file_name(
            file_name=fn, folder_path=path_in_bucket, file_type=file_type)
        with open(fn, 'rb') as f_file:
            logging.info("Uploading file to S3: " + fn)
            bucket.upload_fileobj(Fileobj=f_file, Key=bucket_file_name, ExtraArgs=extra_args)
            logging.info("fileobj uploaded!")


def upload_directory(local_directory, s3_directory, bucket, server_side_encryption,
    storage_class='STANDARD_IA'):
    if server_side_encryption or storage_class:
        extra_args = {}
    if server_side_encryption:
        extra_args["ServerSideEncryption"] = server_side_encryption
    if storage_class:
        extra_args["StorageClass"] = storage_class
    else:
        extra_args = None

    for root, dirs, files in os.walk(local_directory):
        for filename in files:
            local_path = os.path.join(root, filename)
            relative_path = os.path.relpath(local_path, local_directory)
            file_type = relative_path[relative_path.rfind('.') + 1:]
            s3_path = create_bucket_file_name(relative_path, s3_directory, False, file_type)

            with open(local_path, 'rb') as f_file:
                bucket.upload_fileobj(Fileobj=f_file, Key=s3_path, ExtraArgs=extra_args)
                logging.info(f'fileobj {local_path} uploaded!')
    
    index_html_file_path = os.path.join(local_directory, 'index.html')
    with open(index_html_file_path, 'rb') as f_file:
        extra_args['ContentType'] = "text/html"
        bucket.upload_fileobj(Fileobj=f_file, Key='index.html', ExtraArgs=extra_args)
        logging.info('ContentType set to text/html. index.html uploaded successfully')
        my_object = bucket.Object('index.html')
        logging.info(f'index.html content type is: {my_object.content_type}')


logging.basicConfig(format=DEFAULT_LOGGING_FORMAT)
logging.getLogger().setLevel(logging.INFO)

aws_access_key_id = os.environ.get('AWS_CREDENTIAL_ACCESS_KEY_ID')
aws_secret_access_key = os.environ.get('AWS_CREDENTIAL_SECRET_ACCESS_KEY')
bucket_name = os.environ.get('BUCKET_NAME')

bucket = s3_connect_bucket(
    aws_access_key_id,
    aws_secret_access_key,
    AWS_DEFAULT_REGION,
    bucket_name)
local_path = "/app/analytics/target"
upload_directory(
    local_path,
    '',
    bucket,
    None,
    'STANDARD_IA')
