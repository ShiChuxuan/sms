<%@ page contentType="text/html;charset=UTF-8" language="java" session="false" %>
<%
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + 	request.getServerPort() + request.getContextPath() + "/";
%>
<html>
<head>
<base href="<%=basePath%>">
<meta charset="UTF-8">
<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script type="text/javascript">
		$(function () {

			if(window.top!=window){
				window.top.location=window.location; //如果当前窗口不是顶层窗口就将它设置为顶层窗口)
			}

			//页面加载完毕后把用户文本框清空
			$("#loginAct").val("");

			//页面加载完毕后把密码文本框清空
			$("#loginPwd").val("");

			//页面加载完毕之后，用户文本框自动获得焦点
			$("#loginAct").focus();

			//用户文本框获得焦点以后清空错误信息
			$("#loginAct").focus(function () {
				$("#msg").text("");
			})

			//为登录按钮绑定事件
			$("#loginBtn").click(function () {
				login();
			})

			//为窗口绑定敲击事件
			$(window).keydown(function (event) {
				if(event.keyCode==13){
					login();
				}
			})

		})

		//登录方法
		function login(){
			var loginAct = $.trim($("#loginAct").val());
			var loginPwd = $.trim($("#loginPwd").val());
			if(loginAct=="" || loginPwd==""){
				$("#msg").text("账号或密码不能为空");
				return;
			}

			$.ajax({
				url:"settings/user/login.do",
				type:"post",
				data:{
					loginAct:$("#loginAct").val(),
					loginPwd:$("#loginPwd").val()
				},
				dataType:"json",
				success(result){
					if(result.success){
						window.location.href="workbench/index.jsp";
					}else {
						$("#msg").text(result.msg)
					}
				}
			})
		}
	</script>

</head>
<body>
	<div style="position: absolute; top: 0px; left: 0px; width: 60%;">
		<img src="image/IMG_7114.JPG" style="width: 100%; height: 90%; position: relative; top: 50px;">
	</div>
	<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
		<div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">SMS &nbsp;<span style="font-size: 12px;">Supermarket Management System</span></div>
	</div>

	<div style="position: absolute; top: 120px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
		<div style="position: absolute; top: 0px; right: 60px;">
			<div class="page-header">
				<h1>登录</h1>
			</div>
			<form action="workbench/index.jsp" class="form-horizontal" role="form">
				<div class="form-group form-group-lg">
					<div style="width: 350px;">
						<input class="form-control" id="loginAct" type="text" placeholder="用户名">
					</div>
					<div style="width: 350px; position: relative;top: 20px;">
						<input class="form-control" id="loginPwd" type="password" placeholder="密码">
					</div>
					<div class="checkbox"  style="position: relative;top: 30px; left: 10px;">

							<span id="msg" style="color: red"></span>

					</div>
					<button type="button" id="loginBtn" class="btn btn-primary btn-lg btn-block"  style="width: 350px; position: relative;top: 45px;">登录</button>
				</div>
			</form>
		</div>
	</div>
</body>
</html>