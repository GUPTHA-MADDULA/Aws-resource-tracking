
# **Automated AWS Resource Tracking**  

## **Overview**  
This project automates AWS resource tracking using AWS CLI and shell scripting. It periodically collects information about **EC2 instances, S3 buckets, and IAM users**, generating detailed reports to enhance visibility and monitoring of AWS resources.  

## **Features**  
- Tracks **EC2 instances, S3 buckets, and IAM users** in real time.  
- Generates **automated reports** and logs system usage.  
- Uses **Cron Job** for scheduled execution, ensuring consistent monitoring.  
- Reduces manual tracking effort and improves monitoring accuracy.  

## **Prerequisites**  
- AWS CLI must be installed and configured with valid credentials.  
- Shell scripting must be enabled (compatible with Linux, macOS, and WSL).  
- Basic knowledge of cron jobs for scheduling automation.  

## **Setting Up the Cron Job for Automation**  
To ensure the script runs daily at **5:00 PM**, follow these steps:  

### **1. Open the crontab editor**  
Run the following command:  
```bash
crontab -e
```  

### **2. Add the following line at the end of the file**  
```bash
0 17 * * * /home/ec2-user/aws_resource_tracker.sh >> /home/ec2-user/report.log 2>&1
```  
- `0 17 * * *` → Runs the script daily at **5:00 PM**.  
- `/home/ec2-user/aws_resource_tracker.sh` → Path to the AWS tracking script.  
- `>> /home/ec2-user/report.log 2>&1` → Appends output and errors to `report.log`.  

### **3. Save and exit**  
After adding the cron job, save the file and exit the editor.  

### **4. Verify the cron job**  
Run the following command to check if the cron job is successfully added:  
```bash
crontab -l
```  

### Restart the Crontab
Run the following command to Restart the Crontab Service
```bash
sudo systemctl restart crond
```


### **5. Check the logs**  
After execution, you can review the generated logs using:  
```bash
cat /path/report.log
```  

### **6. Troubleshooting Cron Job Issues**  
If the cron job does not execute as expected:  
- Ensure the script has **execute permissions**:  
  ```bash
  chmod +x /path/file.sh
  ```  

## **Conclusion**  
This automated AWS resource tracking system ensures **continuous monitoring and logging of AWS services**. By integrating **cron jobs**, it provides an efficient and scalable solution for AWS resource management.
