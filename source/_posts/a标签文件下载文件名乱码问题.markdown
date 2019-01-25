title: "a标签文件下载文件名乱码问题"
date: 2014-10-16 10:08:10
categories: 前端技术
tags: [前端技术]
---
本文主要介绍在项目测试环境jboss上文件名下载乱码问题的解决。
<!--more-->
近期项目中用到了extjs的上传控件上传文件，然后页面使用a标签直接调用后台action获取流进行下载。在本地tomcat下是没有什么问题的，但是当放到测试环境jboss下的时候却遇到了文件名乱码的问题。以下为关键代码：
```xml
<!-- 附件下载 -->
		<action name="downloadFile"
			class="com.deppon.cc.module.kminfo.server.action.KmInfoAction"
			method="downloadFile">
			<result name="success" type="stream">
				 <param name="contentType">application/octet-stream</param>
	             <param name="inputName">fileStream</param>
	             <param name="contentDisposition">
        				attachment;filename="${fileUpdateFileName}"
   				 </param>
			</result>
		</action>
```
```java
	public InputStream getInputStream(String id){
		if ("".equals(id) || id == null) {
			log.warn("id is null");
			throw new FileStorageException(FileStorageException.COMMON_FILE_IDISBLANK);
		}
		FileEntity res = fileStorageDao.get(id);
		if(res == null) {
			log.warn("get file is null");
			throw new FileStorageException(FileStorageException.COMMON_FILE_GETFILEISBLANK);
		}
		byte[] sfile = res.getSerializedFile();
		//根据ID获取文件
		InputStream fis = new ByteArrayInputStream(sfile);
		return fis;
	}
```
```javascript
/*页面中用<a>标签进行下载*/
var url = "../kminfo/downloadFile.action?kmInfoVO.fileUpdateId=" + annex + "&&kmInfoVO.fileUpdateFileName=" + annexName;
var uploadAttachmentForm = infoEditWindow.down('form').down('form').getForm().findField('fileUpdateNameDisp').setValue("<a href ='"+ url +"'>"+annexName+"</a>");
```
当点击a标签之后，文件名称和文件id会被传到后台，后台根据文件id去查找文件，然后放入流中，struts2中的配置了下载的文件名，它会去调用getFileUpdateFileName()方法去取的文件名,然后再返回到前台。
因为是通过a标签传的中文，在到达后台的时候已经被解码成了不知道什么编码，试着在后台get方法中对文件进行转换：
```java
new String(fileUpdateFileName.getBytes("UTF-8"),"ISO-8859-1");
```
本地可行，但是jboss下还是乱码。试了很多的方法都没办法解决这个问题，最后决定在前台就对中文名进行转码，然后到后台去解码。
```javascript
/*页面中用<a>标签进行下载*/
var url = "../kminfo/downloadFile.action?kmInfoVO.fileUpdateId=" + annex + "&&kmInfoVO.fileUpdateFileName=" + encodeURI(encodeURI(annexName));
var uploadAttachmentForm = infoEditWindow.down('form').down('form').getForm().findField('fileUpdateNameDisp').setValue("<a href ='"+ url +"'>"+annexName+"</a>");
```
这里必须要encodeURI两次，如果是一次的话浏览器还是会把他解析为中文，那么也就无效了。
```java
	public String downloadFile(){
		try {
			getKmInfoVO().setFileUpdateFileName(new String(URLDecoder.decode(getKmInfoVO().getFileUpdateFileName(),"UTF-8").getBytes("UTF-8"),
					"ISO-8859-1"));
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		InputStream fileStream = fileStorageService.getInputStream(getKmInfoVO().getFileUpdateId());
		kmInfoVO.setFileStream(fileStream);
		return SUCCESS;
	}
```
后台只需要URLDecoder一次就可以成功解码了，最后经过在本地和测试环境上都可行。最后再说一下，很多情况下，我们在写程序的时候都会把代码设置为UTF-8的编码，可以在下载文件设置filename的时候却要设置编码格式为ISO-8859-1(如是英文的话就不需要这样处理了)。
先说为什么使用 ISO-8859-1 编码，这个主要是由于http协议，http header头要求其内容必须为iso-8859-1编码，所以我们最终要把其编码为 ISO-8859-1 编码的字符串；
但是前面为什么不直接使用 "中文文件名".getBytes("ISO-8859-1"); 这样的代码呢？因为ISO-8859-1编码的编码表中，根本就没有包含汉字字符，当然也就无法通过"中文文件名".getBytes("ISO-8859-1");来得到正确的“中文文件名”在ISO-8859-1中的编码值了，所以再通过new String()来还原就无从谈起了。 所以先通过 "中文文件名".getBytes("utf-8") 获取其 byte[] 字节，让其按照字节来编码，即在使用 new String("中文文件名".getBytes("utf-8"), "ISO-8859-1") 将其重新组成一个字符串，传送给浏览器。