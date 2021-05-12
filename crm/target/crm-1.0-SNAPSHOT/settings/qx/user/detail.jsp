<%@ page import="com.bjpowernode.crm.settings.domain.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + 	request.getServerPort() + request.getContextPath() + "/";
%>
<html>
<head>
<base href="<%=basePath%>">
<meta charset="UTF-8">
<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/zTree_v3-master/css/zTreeStyle/zTreeStyle.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/zTree_v3-master/js/jquery.ztree.all.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

<SCRIPT type="text/javascript">

	$(function () {

		//日历控件
		$(".time").datetimepicker({
			language:  "zh-CN",
			format: "yyyy-mm-dd hh:ii:ss",//显示格式
			minView: "hour",//设置只显示到月份
			initialDate: new Date(),//初始化当前日期
			autoclose: true,//选中自动关闭
			todayBtn: true, //显示今日按钮
			clearBtn : true,
			pickerPosition: "bottom-left"
		});

		var lockState = "${requestScope.user.lockState}";
		$("#SDZT").text((lockState==1? "启用":"锁定"))
		var admin = "${requestScope.user.admin}";
		$("#GLYQX").text((admin==1? "是":"否"))

		//为编辑按钮绑定事件、打开模态窗口
		$("#editBtn").click(function () {

			//铺数据
			$.ajax({
				url:"settings/user/getUserInDetail.do",
				type:"get",
				data:{
					id:"${requestScope.user.id}"
				},
				dataType:"json",
				success(result){
					$("#edit-loginAct").val(result.loginAct);
					$("#edit-name").val(result.name);
					$("#edit-email").val(result.email);
					$("#edit-expireTime").val(result.expireTime);
					$("#edit-lockState").val(result.lockState);
					$("#edit-admin").val(result.admin);
					$("#edit-allowIps").val(result.allowIps);
				}
			})

			//打开模态窗口
			$("#editUserModal").modal("show");
		})

		//为更新按钮绑定事件
		$("#updateBtn").click(function () {
			$.ajax({
				url:"settings/user/edit.do",
				type:"get",
				data:{
					id:"${requestScope.user.id}",
					loginAct:$("#edit-loginAct").val(),
					name:$("#edit-name").val(),
					email:$("#edit-email").val(),
					expireTime:$("#edit-expireTime").val(),
					lockState:$("#edit-lockState").val(),
					admin:$("#edit-admin").val(),
					allowIps: $("#edit-allowIps").val()

				},
				dataType: "json",
				success(result){
					if(result.success){
						alert("更新成功！");
						//更新页面数据
						$("#DBT").text(result.user.name);
						$("#DLZH").text(result.user.loginAct);
						$("#YX").text(result.user.email);
						$("#YHXM").text(result.user.name);
						$("#SXSJ").text(result.user.expireTime);
						$("#YXFWIP").text(result.user.allowIps);
						$("#SDZT").text((result.user.lockState==1? "启用":"锁定"));
						$("#GLYQX").text((result.user.admin==1? "是":"否"));
						$("#XGZ").text(result.user.editBy);
						$("#XGSJ").text(result.user.editTime);
					}else{
						alert("更新失败！");
					}
				}
			})
		})
	})


</SCRIPT>


</head>
<body>

	<!-- 编辑用户的模态窗口 -->
	<div class="modal fade" id="editUserModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">编辑用户</h4>
				</div>
				<div class="modal-body">

					<form class="form-horizontal" role="form" id="editUserForm">

						<div class="form-group">
							<label for="edit-loginAct" class="col-sm-2 control-label">登录帐号</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-loginAct">
							</div>
							<label for="edit-name" class="col-sm-2 control-label">用户姓名</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-name">
							</div>
						</div>
						<div class="form-group">
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email">
							</div>
							<label for="edit-expireTime" class="col-sm-2 control-label">失效时间</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-expireTime" readonly>
							</div>
						</div>
						<div class="form-group">
							<label for="edit-lockState" class="col-sm-2 control-label">锁定状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-lockState">
									<option></option>
									<option value="1">启用</option>
									<option value="0">锁定</option>
								</select>
							</div>

							<label for="edit-admin" class="col-sm-2 control-label">管理员权限</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-admin">
									<option></option>
									<option value="1">是</option>
									<option value="0">否</option>
								</select>
							</div>

						</div>
						<div class="form-group">
							<label for="edit-allowIps" class="col-sm-2 control-label">允许访问的IP</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-allowIps" style="width: 280%" placeholder="多个用逗号隔开">
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="updateBtn">更新</button>
				</div>
			</div>
		</div>
	</div>

	<div>
		<div style="position: relative; left: 30px; top: -10px;">
			<div class="page-header">
				<h3>用户详情 <small id="DBT">${requestScope.user.name}</small></h3>
			</div>
			<div style="position: relative; height: 50px; width: 250px;  top: -72px; left: 80%;">
				<button type="button" class="btn btn-default" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left"></span> 返回</button>
			</div>
		</div>
	</div>
	
	<div style="position: relative; left: 60px; top: -50px;">
		
		<div id="myTabContent" class="tab-content">
			<div class="tab-pane fade in active" id="role-info">
				<div style="position: relative; top: 20px; left: -30px;">
					<div style="position: relative; left: 40px; height: 30px; top: 20px;">
						<div style="width: 300px; color: gray;">登录帐号</div>
						<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="DLZH">${requestScope.user.loginAct}</b></div>
						<div style="height: 1px; width: 600px; background: #D5D5D5; position: relative; top: -20px;"></div>
					</div>
					<div style="position: relative; left: 40px; height: 30px; top: 40px;">
						<div style="width: 300px; color: gray;">用户姓名</div>
						<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="YHXM">${requestScope.user.name}</b></div>
						<div style="height: 1px; width: 600px; background: #D5D5D5; position: relative; top: -20px;"></div>
					</div>
					<div style="position: relative; left: 40px; height: 30px; top: 60px;">
						<div style="width: 300px; color: gray;">邮箱</div>
						<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="YX">${requestScope.user.email}</b></div>
						<div style="height: 1px; width: 600px; background: #D5D5D5; position: relative; top: -20px;"></div>
					</div>
					<div style="position: relative; left: 40px; height: 30px; top: 80px;">
						<div style="width: 300px; color: gray;">失效时间</div>
						<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="SXSJ">${requestScope.user.expireTime}</b></div>
						<div style="height: 1px; width: 600px; background: #D5D5D5; position: relative; top: -20px;"></div>
					</div>
					<div style="position: relative; left: 40px; height: 30px; top: 100px;">
						<div style="width: 300px; color: gray;">允许访问IP</div>
						<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="YXFWIP">${requestScope.user.allowIps}</b></div>
						<div style="height: 1px; width: 600px; background: #D5D5D5; position: relative; top: -20px;"></div>
					</div>
					<div style="position: relative; left: 40px; height: 30px; top: 120px;">
						<div style="width: 300px; color: gray;">锁定状态</div>
						<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="SDZT"></b></div>
						<div style="height: 1px; width: 600px; background: #D5D5D5; position: relative; top: -20px;"></div>
					</div>
					&nbsp;
					<div style="position: relative; left: 40px; height: 30px; top: 120px;">
						<div style="width: 300px; color: gray;">管理权限</div>
						<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="GLYQX"></b></div>
						<div style="height: 1px; width: 600px; background: #D5D5D5; position: relative; top: -20px;"></div>
					</div>
					&nbsp;
					<div style="position: relative; left: 40px; height: 30px; top: 120px;">
						<div style="width: 300px; color: gray;">创建者</div>
						<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="CJZ">${requestScope.user.createBy}</b></div>
						<div style="height: 1px; width: 600px; background: #D5D5D5; position: relative; top: -20px;"></div>
					</div>
					&nbsp;
					<div style="position: relative; left: 40px; height: 30px; top: 120px;">
						<div style="width: 300px; color: gray;">创建时间</div>
						<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="CJSJ">${requestScope.user.createTime}</b></div>
						<div style="height: 1px; width: 600px; background: #D5D5D5; position: relative; top: -20px;"></div>
					</div>
					&nbsp;
					<div style="position: relative; left: 40px; height: 30px; top: 120px;">
						<div style="width: 300px; color: gray;">修改者</div>
						<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="XGZ">${requestScope.user.editBy}</b></div>
						<div style="height: 1px; width: 600px; background: #D5D5D5; position: relative; top: -20px;"></div>
					</div>
					&nbsp;
					<div style="position: relative; left: 40px; height: 30px; top: 120px;">
						<div style="width: 300px; color: gray;">修改时间</div>
						<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="XGSJ">${requestScope.user.editTime}</b></div>
						<div style="height: 1px; width: 600px; background: #D5D5D5; position: relative; top: -20px;"></div>
						<button style="position: relative; left: 76%; top: -40px;" type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
					</div>
				</div>
			</div>
		</div>
	</div>	
	
</body>
</html>