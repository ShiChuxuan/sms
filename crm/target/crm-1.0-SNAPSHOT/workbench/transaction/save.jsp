<%@ page import="java.util.Set" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + 	request.getServerPort() + request.getContextPath() + "/";
	Map<String,String> pMap = (Map) application.getAttribute("pMap");
	Set<String> set = pMap.keySet();

%>
<html>
<head>
<meta charset="UTF-8">
<base href="<%=basePath%>">
<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>
	<script type="text/javascript">
		var json = {
			<%
                for (String key:set){
                    String value = pMap.get(key);
            %>

			"<%=key%>" : <%=value%>,
			//这是一个前端手写的js，两个大括号就代表是json。最后的逗号js会自动帮我们屏蔽掉，不用再去判断了

			<%
                }

            %>

		};



		$(function () {
			//日历控件
			$(".time").datetimepicker({
				minView: "month",
				language:  'zh-CN',
				format: 'yyyy-mm-dd',
				autoclose: true,
				todayBtn: true,
				pickerPosition: "bottom-left"
			});

			//填充所有者下拉框
			$.ajax({
				url:"workbench/Tran/getUserList.do",
				type:"get",
				dataType:"json",
				success(result){
					var html = '<option></option>';
					$.each(result,function (i,n) {
						html+= '<option value="'+n.id+'">'+n.name+'</option>';
					})
					$("#create-owner").html(html);
					$("#create-owner").val("${sessionScope.user.id}");
				}
			})

			//自动补全
			$("#create-customer").typeahead({
				source: function (query, process) {
					$.get(
							"workbench/Tran/getCustomerName.do",
							{ "name" : query },
							function (data) {
								//alert(data);
								/*
								* 	data
								* 		[{客户名称1}，{2}，{3}]
								*
								* */
								process(data);
							},
							"json"
					);
				},
				delay: 1000
			});


			//为搜索联系人放大镜绑定事件
			$("#searchContact").click(function () {
				$("#cname").val("");
				$.ajax({
					url:"workbench/Tran/getAllContacts.do",
					type: "get",
					dataType:"json",
					success(result){
						var html = '';
						$.each(result,function (i,n) {
							html+='<tr>';
							html+='<td><input type="radio" name="contacts" value="'+n.id+'"/></td>';
							html+='<td id="c'+n.id+'">'+n.fullname+'</td>';
							html+='<td>'+n.email+'</td>';
							html+='<td>'+n.mphone+'</td>';
							html+='</tr>';
						})
						$("#tBody1").html(html);
						$("#findContacts").modal("show");
					}
				})

			})

			//为搜索框绑定回车事件
			$("#cname").keydown(function (event) {
				if(event.keyCode==13){
					$.ajax({
						url:"workbench/Tran/searchContacts.do",
						type:"get",
						data:{
							name:$("#cname").val(),
						},
						dataType:"json",
						success(result){
							var html = '';
							$.each(result,function (i,n) {
								html+='<tr>';
								html+='<td><input type="radio" name="contacts" value="'+n.id+'"/></td>';
								html+='<td>'+n.fullname+'</td>';
								html+='<td>'+n.email+'</td>';
								html+='<td>'+n.mphone+'</td>';
								html+='</tr>';
							})
							$("#tBody1").html(html);

						}
					})
					return false;
				}


			})


			//为提交按钮绑定事件
			$("#submitContactBtn").click(function () {
				var id = $("input[name=contacts]:checked").val();
				$("#create-contactsId").val(id);
				$("#create-contacts").val($("#c"+id).text());
				$("#findContacts").modal("hide");
			})


			$("#create-stage").change(function () {
				//取得选中的阶段，this表示这个Jquery对象的dom对象
				var stage = this.value;
				$("#create-possibility").val(json[stage]+"%");

			})


			//为保存按钮绑定事件
			$("#saveBtn").click(function(){
				$.ajax({
					url:"workbench/Tran/addTran.do",
					type:"post",
					data:{
						owner:$("#create-owner").val(),
						money:$("#create-money").val(),
						name:$("#create-name").val(),
						expectedDate:$("#create-expectedDate").val(),
						customerId:$("#create-customer").val(),
						stage:$("#create-stage").val(),
						type:$("#create-type").val(),
						source:$("#create-source").val(),
						contactsId: $("#create-contactsId").val(),
						description:$("#create-description").val(),
						contactSummary:$("#create-contactSummary").val(),
						nextContactTime:$("#create-nextContactTime").val(),
						possibility:$("#create-possibility").val()
					},
					dataType:"json",
					success(result){
						if(result.success){
							alert("添加成功！");
							location.href="workbench/transaction/index.jsp";
						}else{
							alert("添加失败！");
						}
					}
				})
			})


			//为取消按钮绑定事件
			$("#cancelBtn").click(function () {
				location.href = "workbench/transaction/index.jsp";
			})


		})
	</script>


</head>
<body>

	<!-- 查找联系人 -->	
	<div class="modal fade" id="findContacts" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找联系人</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" style="width: 300px;" id="cname" placeholder="请输入联系人名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>邮箱</td>
								<td>手机</td>
							</tr>
						</thead>
						<tbody id="tBody1">
							<%--<tr>
								<td><input type="radio" name="activity"/></td>
								<td>李四</td>
								<td>lisi@bjpowernode.com</td>
								<td>12345678901</td>
							</tr>
							<tr>
								<td><input type="radio" name="activity"/></td>
								<td>李四</td>
								<td>lisi@bjpowernode.com</td>
								<td>12345678901</td>
							</tr>--%>
						</tbody>
					</table>
					<div class="modal-footer">
						<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
						<button type="button" class="btn btn-primary" id="submitContactBtn">提交</button>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	
	<div style="position:  relative; left: 30px;">
		<h3>创建交易</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button type="button" id="saveBtn" class="btn btn-primary">保存</button>
			<button type="button" id="cancelBtn" class="btn btn-default">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal" role="form" style="position: relative; top: -30px;">
		<div class="form-group">
			<label for="create-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-owner">

				</select>
			</div>
			<label for="create-money" class="col-sm-2 control-label">金额</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-money">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-name">
			</div>
			<label for="create-expectedDate" class="col-sm-2 control-label">预计成交日期<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control time" id="create-expectedDate" readonly>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-customer" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-customer" placeholder="支持自动补全，输入客户不存在则新建">
			</div>
			<label for="create-stage" class="col-sm-2 control-label">阶段<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
			  <select class="form-control" id="create-stage">
			  	<option></option>
			  	<c:forEach var="a" items="${stage}">
					<option value="${a.value}">${a.text}</option>
				</c:forEach>
			  </select>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-type" class="col-sm-2 control-label">类型</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-type">
				  <option></option>
				  <option value="已有业务">已有业务</option>
				  <option value="新业务">新业务</option>
				</select>
			</div>
			<label for="create-possibility" class="col-sm-2 control-label">可能性</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-possibility" readonly>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-source" class="col-sm-2 control-label">来源</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-source">
				  <option></option>
					<c:forEach var="a" items="${source}">
						<option value="${a.value}">${a.text}</option>
					</c:forEach>
				</select>
			</div>

			<label for="create-contacts" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a href="javascript:void(0);"  id="searchContact"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-contacts">
				<input type="hidden" id="create-contactsId">
			</div>
		</div>
		

		
		<div class="form-group">
			<label for="create-description" class="col-sm-2 control-label">描述</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-description"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control time" id="create-nextContactTime" readonly>
			</div>
		</div>
		
	</form>
</body>
</html>