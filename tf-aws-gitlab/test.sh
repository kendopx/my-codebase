# 1. Create an IAM user by running the following command
aws iam create-user --user-name deployer

# 2. (Optional) If you have not created an Admin group already, you can create one in this step, else skip to step 5. Run the following command to create a user group
aws iam create-group --group-name admin-group

# 3. Attach the AdministratorAccess policy to the group created
aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/AdministratorAccess --group-name admin-group

# 4. To check if the policy has been attached to the group, you can check by running the following command
aws iam list-attached-group-policies --group-name admin-group

# 5. Add the Admin user to the Admin group by running the following command
aws iam add-user-to-group --user-name deployer --group-name admin-group

# 6. To check if the user got added to the group, run the following command
aws iam list-groups-for-user --user-name deployer


