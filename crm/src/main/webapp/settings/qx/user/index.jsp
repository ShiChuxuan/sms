<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js" charset="GBK"></script>
<script type="text/javascript" src="jquery/bs_pagination/en.js" charset="GBK"></script>


	<script>

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


			//防止恶意进入页面
			//判断是不是管理员
			if("${sessionScope.user.admin}"!=1){
				window.location.href="workbench/index.jsp";
			}

			//为查询按钮绑定事件
			$("#search-Btn").click(function () {
				//将搜索框中的文本传入隐藏域
				$("#hidden-name").val($.trim($("#search-name").val()));
				$("#hidden-lockState").val($.trim($("#search-lockState").val()));
				pageList(1,2);
			})

			//为全选与全不选
			$("#qx").click(function () {
				$("input[name=xz]").prop("checked",this.checked);
			})
			$("#userBody").on("click",$("input[name=xz]"),function () {
				if($("input[name=xz]:checked").length==$("input[name=xz]").length){
					$("#qx").prop("checked",true);
				}else{
					$("#qx").prop("checked",false);
				}
			})

			//删除用户
			$("#deleteBtn").click(function () {
				var $xz = $("input[name=xz]:checked");
				if($xz.length==0){
					alert("至少选择一个用户进行删除！")
					return;
				}else{
					if(confirm("确认删除所选的用户吗？")){
						var param = '';
						$.each($xz,function (i,n) {
							param += 'id='+n.value
							if(i<$xz.length-1){
								param += '&';
							}
						})
						$.ajax({
							url:"settings/user/delete.do",
							type:"get",
							data:param,
							dataType: "json",
							success(result){
								if(result.success){
									alert("删除成功！");
									pageList(1,$("#userPage").bs_pagination('getOption', 'rowsPerPage'));
								}else{
									alert("删除失败！")
								}
							}
						})
					}
				}
			})


			//为创建按钮绑定事件打开模态窗口
			$("#addBtn").click(function () {

				$("#createUserModal").modal("show");
			})

			//为保存按钮绑定事件
			$("#saveBtn").click(function () {
				//将错误消息清空
				$("#msg1").text("");
				$("#msg2").text("");
				$("#msg3").text("");
				//去掉所有空格
				var loginAct = $("#create-loginAct").val().replace(/\s/g, "")
				var loginPwd = $("#create-loginPwd").val().replace(/\s/g, "")
				var confirmPwd = $("#create-confirmPwd").val().replace(/\s/g, "")

				//判断
				if(loginAct==""){
					$("#msg1").text("登录账号不能为空！");
					return;
				}
				if(loginPwd==""){
					$("#msg2").text("登录密码不能为空且不能包含空格！");
					return;
				}
				if(loginPwd!=confirmPwd){
					$("#msg3").text("两次密码不一致");
					return;
				}

				$.ajax({
					url:"settings/user/add.do",
					type:"post",
					data:{
						loginAct:loginAct,
						name:$.trim($("#create-name").val()),
						loginPwd:loginPwd,
						email:$.trim($("#create-email").val()),
						expireTime:$.trim($("#create-expireTime").val()),
						lockState: $.trim($("#create-lockState").val()),
						allowIps:$.trim($("#create-allowIps").val()),
						admin:$.trim($("#create-admin").val())

					},
					dataType:"json",
					success(result){
						if(result.success){
							alert("添加成功！");
							var addUserForm = $("#addUserForm")[0]
							addUserForm.reset();
							$("#createUserModal").modal("hide");
							pageList(1,$("#userPage").bs_pagination('getOption', 'rowsPerPage'));
						}else{
							alert("添加失败！")
						}
					}
				})

			})

			pageList(1,5);

		})

		function pageList(pageNo,pageSize) {

			//将全选复选框的√去掉
			$("#qx").prop("checked",false);


			//将隐藏域中的值重新赋给搜索框
			$("#search-name").val($("#hidden-name").val());
			$("#search-lockState").val($("#hidden-lockState").val());

			$.ajax({
				url:"settings/user/pageList.do",
				type:"get",
				data:{
					name:$("#search-name").val(),
					lockState:$("#search-lockState").val(),
					pageNo:pageNo,
					pageSize:pageSize
				},
				dataType:"json",
				success(result){
					var html = '';
					$.each(result.dataList,function (i,n) {
					i = i+1;
					html+='<tr class="active">'
					html+='<td><input type="checkbox" name="xz" value="'+n.id+'"/></td>'
					html+='<td>'+i+'</td>'
					html+='<td><a  href="settings/user/getDetail.do?id='+n.id+'">'+n.loginAct+'</a></td>'
					html+='<td>'+n.name+'</td>'
					html+='<td>'+n.email+'</td>'
					html+='<td>'+n.expireTime+'</td>'
					html+='<td>'+n.allowIps+'</td>'
					html+='<td>'+(n.lockState==1? "启用":"锁定")+'</td>'
					html+='<td>'+n.createBy+'</td>'
					html+='<td>'+n.createTime+'</td>'
					html+='<td>'+n.editBy+'</td>'
					html+='<td>'+n.editTime+'</td>'
					html+='</tr>'
					})
					$("#userBody").html(html);

					//总页数
					var totalPages = Math.ceil(result.total/pageSize);


					//分页插件
					$("#userPage").bs_pagination({
						currentPage: pageNo, // 页码
						rowsPerPage: pageSize, // 每页显示的记录条数
						maxRowsPerPage: 20, // 每页最多显示的记录条数
						totalPages: totalPages, // 总页数
						totalRows: result.total, // 总记录条数

						visiblePageLinks: 3, // 显示几个卡片

						showGoToPage: true,
						showRowsPerPage: true,
						showRowsInfo: true,
						showRowsDefaultInfo: true,

						onChangePage : function(event, data){
							pageList(data.currentPage , data.rowsPerPage);
						}
					});
				}

			})

		}

	</script>
</head>
<body>
<input type="hidden" id="hidden-name">
<input type="hidden" id="hidden-lockState">


	<!-- 创建用户的模态窗口 -->
	<div class="modal fade" id="createUserModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">新增用户</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form" id="addUserForm">
					
						<div class="form-group">
							<label for="create-loginAct" class="col-sm-2 control-label">登录帐号<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-loginAct">
								<span id="msg1" style="color: red"></span>
							</div>
							<label for="create-name" class="col-sm-2 control-label">用户姓名</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-name">
							</div>
						</div>
						<div class="form-group">
							<label for="create-loginPwd" class="col-sm-2 control-label">登录密码<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="password" class="form-control" id="create-loginPwd">
								<span id="msg2" style="color: red"></span>
							</div>
							<label for="create-confirmPwd" class="col-sm-2 control-label">确认密码<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="password" class="form-control" id="create-confirmPwd">
								<span id="msg3" style="color: red"></span>
							</div>
						</div>
						<div class="form-group">
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
							<label for="create-expireTime" class="col-sm-2 control-label">失效时间</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-expireTime" readonly>
							</div>
						</div>
						<div class="form-group">
							<label for="create-lockState" class="col-sm-2 control-label">锁定状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-lockState">
								  <option></option>
								  <option value="1">启用</option>
								  <option value="0">锁定</option>
								</select>
							</div>

							<label for="create-admin" class="col-sm-2 control-label">管理员权限</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-admin">
									<option></option>
									<option value="1">是</option>
									<option value="0">否</option>
								</select>
							</div>

						</div>
						<div class="form-group">
							<label for="create-allowIps" class="col-sm-2 control-label">允许访问的IP</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-allowIps" style="width: 280%" placeholder="多个用逗号隔开">
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	
	<div>
		<div style="position: relative; left: 30px; top: -10px;">
			<div class="page-header">
				<h3>用户列表</h3>
			</div>
		</div>
	</div>
	
	<div class="btn-toolbar" role="toolbar" style="position: relative; height: 80px; left: 30px; top: -10px;">
		<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
		  
		  <div class="form-group">
		    <div class="input-group">
		      <div class="input-group-addon">用户姓名</div>
		      <input class="form-control" type="text" id="search-name">
		    </div>
		  </div>
		  &nbsp;&nbsp;&nbsp;&nbsp;
		  <div class="form-group">
		    <div class="input-group">
		      <div class="input-group-addon">锁定状态</div>
			  <select class="form-control" id="search-lockState">
			  	  <option></option>
			      <option value="0">锁定</option>
				  <option value="1">启用</option>
			  </select>
		    </div>
		  </div>
			&nbsp;&nbsp;&nbsp;&nbsp;
		  <button type="button" class="btn btn-default" id="search-Btn">查询</button>
		  
		</form>
	</div>
	
	
	<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;left: 30px; width: 110%; top: 20px;">
		<div class="btn-group" style="position: relative; top: 18%;">
		  <button type="button" class="btn btn-primary" id="addBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
		  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
		
	</div>
	
	<div style="position: relative; left: 30px; top: 40px; width: 110%">
		<table class="table table-hover">
			<thead>
				<tr style="color: #B3B3B3;">
					<td><input type="checkbox" id="qx"/></td>
					<td>序号</td>
					<td>登录帐号</td>
					<td>用户姓名</td>
					<td>邮箱</td>
					<td>失效时间</td>
					<td>允许访问IP</td>
					<td>锁定状态</td>
					<td>创建者</td>
					<td>创建时间</td>
					<td>修改者</td>
					<td>修改时间</td>
				</tr>
			</thead>
			<tbody id="userBody">

			</tbody>
		</table>
	</div>
	
	<div style="height: 50px; position: relative;top: 30px; left: 30px;">
		<div id="userPage"></div>
	</div>
			
</body>
</html>