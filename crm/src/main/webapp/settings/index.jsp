<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
	<script>
		$(function () {

			//防止恶意进入页面
			//判断是不是管理员
			if("${sessionScope.user.admin}"!=1){
				window.location.href="workbench/index.jsp";
			}




			$("#updatePwdBtn").click(function () {
				$("#msg").text("");

				var oldPwd = $("#oldPwd").val();
				var newPwd = $("#newPwd").val();
				var confirmPwd = $("#confirmPwd").val();
				if(newPwd != confirmPwd){
					$("#msg").text("两次密码不一致");
					return;
				}
				$.ajax({
					url:"settings/user/resetPwd.do",
					type:"post",
					data:{
						oldPwd:oldPwd,
						newPwd:newPwd,
					},
					dataType:"json",
					success(result){
						if(result.success){
							alert("修改成功,请重新登录");
							window.location.href="login.jsp"
						}else{
							alert("修改失败！");
							alert(result.msg);
						}
					}
				})

			})
		})
	</script>
</head>
<body>

	<!-- 我的资料 -->
	<div class="modal fade" id="myInformation" role="dialog">
		<div class="modal-dialog" role="document" style="width: 30%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">我的资料</h4>
				</div>
				<div class="modal-body">
					<div style="position: relative; left: 40px;">
						姓名：<b>${sessionScope.user.name}</b><br><br>
						登录帐号：<b>${sessionScope.user.loginAct}</b><br><br>
						邮箱：<b>${sessionScope.user.email}</b><br><br>
						失效时间：<b>${sessionScope.user.expireTime}</b><br><br>
						允许访问IP：<b>${sessionScope.user.allowIps}</b>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
				</div>
			</div>
		</div>
	</div>
	

	<!-- 修改密码的模态窗口 -->
	<div class="modal fade" id="editPwdModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 70%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">修改密码</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
						<div class="form-group">
							<label for="oldPwd" class="col-sm-2 control-label">原密码</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="password" class="form-control" id="oldPwd" style="width: 200%;">
							</div>
						</div>

						<div class="form-group">
							<label for="newPwd" class="col-sm-2 control-label">新密码</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="password" class="form-control" id="newPwd" style="width: 200%;">
							</div>
						</div>

						<div class="form-group">
							<label for="confirmPwd" class="col-sm-2 control-label">确认密码</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="password" class="form-control" id="confirmPwd" style="width: 200%;"><span id="msg" style="color: red"></span>
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-primary" id="updatePwdBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 退出系统的模态窗口 -->
	<div class="modal fade" id="exitModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 30%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">离开</h4>
				</div>
				<div class="modal-body">
					<p>您确定要退出系统吗？</p>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-primary" data-dismiss="modal" onclick="window.location.href='settings/user/exit.do';">确定</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 顶部 -->
	<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
		<div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">SMS &nbsp;<span style="font-size: 12px;">Supermarket Management System</span></div>
		<div style="position: absolute; top: 15px; right: 15px;">
			<ul>
				<li class="dropdown user-dropdown">
					<a href="javascript:void(0)" style="text-decoration: none; color: white;" class="dropdown-toggle" data-toggle="dropdown">
						<span class="glyphicon glyphicon-user"></span> ${sessionScope.user.name} <span class="caret"></span>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					</a>
					<ul class="dropdown-menu">
						<li><a href="workbench/index.jsp"><span class="glyphicon glyphicon-home"></span> 工作台</a></li>
						<li><a href="settings/index.jsp"><span class="glyphicon glyphicon-wrench"></span> 系统设置</a></li>
						<li><a href="javascript:void(0)" data-toggle="modal" data-target="#myInformation"><span class="glyphicon glyphicon-file"></span> 我的资料</a></li>
						<li><a href="javascript:void(0)" data-toggle="modal" data-target="#editPwdModal"><span class="glyphicon glyphicon-edit"></span> 修改密码</a></li>
						<li><a href="javascript:void(0);" data-toggle="modal" data-target="#exitModal"><span class="glyphicon glyphicon-off"></span> 退出</a></li>
					</ul>
				</li>
			</ul>
		</div>
	</div>
	
	<!-- 中间 -->
	<div id="center" style="position: absolute;top: 50px; bottom: 30px; left: 0px; right: 0px;">
		<div style="position: relative; top: 30px; width: 60%; height: 100px; left: 20%;">
			<div class="page-header">
			  <h3>系统设置</h3>
			</div>
		</div>
		<div style="position: relative; width: 55%; height: 70%; left: 22%;">
			<div style="position: relative; width: 33%; height: 50%;">
				安全控制
				<br><br>
				<a href="settings/qx/index.jsp">权限管理</a>
			</div>
			<div style="position: relative; width: 33%; height: 50%;">
				数据管理
				<br><br>
				<a href="settings/dictionary/index.html">数据字典表</a>
			</div>
		</div>
	</div>
</body>
</html>