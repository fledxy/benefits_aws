aws iam create-role \
  --role-name amazoneks_ebs_csi_driver_role \
  --assume-role-policy-document file://"aws-ebs-csi-driver-trust-policy.json"
aws iam attach-role-policy \
  --policy-arn arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy \
  --role-name amazoneks_ebs_csi_driver_role