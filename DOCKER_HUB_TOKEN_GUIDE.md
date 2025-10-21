# Docker Hub Token Setup Guide

## 🔐 **Using Docker Hub Tokens (Recommended)**

Docker Hub tokens are more secure than passwords and provide better access control.

## 📋 **How to Create Docker Hub Token**

### **Step 1: Login to Docker Hub**
1. Go to: `https://hub.docker.com/`
2. Login with your Docker Hub account

### **Step 2: Create Access Token**
1. Click on your **profile picture** (top right)
2. Select **"Account Settings"**
3. Go to **"Security"** tab
4. Click **"New Access Token"**

### **Step 3: Configure Token**
- **Access Token Description**: `GitHub Actions Weather API`
- **Access permissions**: Select **"Read, Write, Delete"**
- Click **"Generate"**

### **Step 4: Copy Token**
- **Important**: Copy the token immediately (you won't see it again)
- Token format: `dckr_pat_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`

## 🔧 **GitHub Secrets Configuration**

### **Go to Repository Secrets**
`https://github.com/naimuddin-bs23/weather-api/settings/secrets/actions`

### **Add These Secrets**:
```
WEATHER_API_KEY=abd9523d2a02b6fc7ae21bb4e7c86f4c
DOCKER_USERNAME=your_docker_hub_username
DOCKER_TOKEN=dckr_pat_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

## ✅ **Token Benefits**

### **Security**
- ✅ **No Password Exposure**: Your Docker Hub password stays private
- ✅ **Revocable**: Can revoke token without changing password
- ✅ **Scoped Access**: Limited to specific permissions
- ✅ **Audit Trail**: Track token usage

### **Best Practices**
- ✅ **Unique Tokens**: One token per application/service
- ✅ **Descriptive Names**: Easy to identify token purpose
- ✅ **Regular Rotation**: Update tokens periodically
- ✅ **Minimal Permissions**: Only grant necessary access

## 🚀 **Pipeline Configuration**

### **Current CI/CD Setup**
```yaml
- name: Log in to Docker Hub
  uses: docker/login-action@v3
  with:
    username: ${{ secrets.DOCKER_USERNAME }}
    password: ${{ secrets.DOCKER_TOKEN }}
```

### **What Happens**
1. ✅ **Authentication**: Uses token to login to Docker Hub
2. ✅ **Build**: Creates Docker image
3. ✅ **Push**: Uploads to `naimuddin-bs23/weather-api`
4. ✅ **Deploy**: Pulls image for deployment

## 🔍 **Verify Token Works**

### **Test Token Locally**
```bash
# Test Docker Hub login with token
echo "your_token_here" | docker login --username your_username --password-stdin

# Should show: "Login Succeeded"
```

### **Check Token Permissions**
- Go to Docker Hub → Account Settings → Security
- Verify token has "Read, Write, Delete" permissions
- Check token is active (not expired)

## 🛠️ **Troubleshooting**

### **Common Issues**

#### **Token Not Working**
- ✅ Check token is copied correctly (no extra spaces)
- ✅ Verify token hasn't expired
- ✅ Confirm token has correct permissions

#### **Authentication Failed**
- ✅ Verify `DOCKER_USERNAME` matches Docker Hub username
- ✅ Check `DOCKER_TOKEN` is the access token (not password)
- ✅ Ensure token has push permissions

#### **Permission Denied**
- ✅ Token needs "Write" permission to push images
- ✅ Repository must exist or be public
- ✅ Username must match repository owner

## 📊 **Token Management**

### **Monitor Token Usage**
- Go to Docker Hub → Account Settings → Security
- View token usage and activity
- Revoke unused tokens

### **Rotate Tokens**
- Create new token
- Update GitHub secret
- Revoke old token
- Test new token works

## 🎯 **Quick Setup Checklist**

- [ ] Create Docker Hub account (if needed)
- [ ] Generate access token with "Read, Write, Delete" permissions
- [ ] Copy token (save securely)
- [ ] Add `DOCKER_USERNAME` secret in GitHub
- [ ] Add `DOCKER_TOKEN` secret in GitHub
- [ ] Add `WEATHER_API_KEY` secret in GitHub
- [ ] Test pipeline with release

## 🎉 **Ready for Deployment**

With Docker Hub token configured:
- ✅ **Secure Authentication**: No password exposure
- ✅ **Automated Builds**: Pipeline pushes to Docker Hub
- ✅ **Easy Deployment**: Pull from public registry
- ✅ **Version Control**: Tagged releases

**Status**: ✅ **DOCKER HUB TOKEN CONFIGURATION READY** 🚀
