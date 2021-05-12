<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + 	request.getServerPort() + request.getContextPath() + "/";
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
<link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>
<script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>

<script type="text/javascript">

	$(function(){
		
		//定制字段
		$("#definedColumns > li").click(function(e) {
			//防止下拉菜单消失
	        e.stopPropagation();
	    });

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
			url:"workbench/Contacts/getUserList.do",
			type:"get",
			dataType:"json",
			success(result){
				var html = '<option></option>';
				$.each(result,function (i,n) {
					html+='<option value="'+n.id+'">'+n.name+'</option>'
				})
				$("#search-owner").html(html);
				$("#search-owner").val("${sessionScope.user.id}");
			}
		})

		//为查询按钮绑定事件
		$("#searchBtn").click(function () {
			//将搜索框中的内容赋给隐藏域
			$("#hidden-owner").val($.trim($("#search-owner").val()));
			$("#hidden-fullname").val($.trim($("#search-fullname").val()));
			$("#hidden-customer").val($.trim($("#search-customer").val()));
			$("#hidden-source").val($.trim($("#search-source").val()));
			$("#hidden-birth").val($.trim($("#search-birth").val()));
			pageList(1,2);
		})

		//为创建按钮绑定事件
		$("#addBtn").click(function(){
			$.ajax({
				url:"workbench/Contacts/getUserList.do",
				type:"get",
				dataType:"json",
				success(result){
					var html = '<option></option>';
					$.each(result,function (i,n) {
						html+='<option value="'+n.id+'">'+n.name+'</option>'
					})
					$("#create-owner").html(html);
					$("#create-owner").val("${sessionScope.user.id}");
					$("#createContactsModal").modal("show");
				}
			})


		//自动补全插件关键代码
			$("#create-customerName").typeahead({
				source: function (query, process) {
					$.get(
							"workbench/Contacts/getCustomerName.do",
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
				delay: 1500
			});
			$("#edit-customer").typeahead({
				source: function (query, process) {
					$.get(
							"workbench/Contacts/getCustomerName.do",
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
				delay: 1500
			});



		//为保存按钮绑定事件
			$("#saveBtn").click(function () {
				$.ajax({
					url:"workbench/Contacts/addContacts.do",
					type:"post",
					data:{
						owner:$("#create-owner").val(),
						source:$("#create-source").val(),
						fullname:$("#create-fullname").val(),
						appellation:$("#create-appellation").val(),
						job:$("#create-job").val(),
						mphone:$("#create-mphone").val(),
						email:$("#create-email").val(),
						birth:$("#create-birth").val(),
						customerId:$("#create-customerName").val(),
						description:$("#create-description").val(),
						nextContactTime:$("#create-nextContactTime").val(),
						contactSummary:$("#create-contactSummary").val(),
						address:$("#create-address").val()

					},
					dataType:"json",
					success(result){
						if(result.success){
							alert("创建成功！");
							pageList(1,$("#contactsPage").bs_pagination('getOption', 'rowsPerPage'));
							var addContactsForm = $("#addContactsForm")[0];
							addContactsForm.reset();
							$("#createContactsModal").modal("hide");
						}else{
							alert("创建失败！")
						}
					}
				})
			})




		})

		//为修改按钮绑定事件
		$("#editBtn").click(function(){
			if($("input[name=xz]:checked").length==0){
				alert("至少选择一个联系人进行修改！");
				return;
			}
			if($("input[name=xz]:checked").length>1){
				alert("每次修改不能超过一个联系人！");
				return;
			}
			$.ajax({
				url:"workbench/Contacts/getUserListAndContacts.do",
				type:"get",
				data:{
					id:$("input[name=xz]:checked").val()
				},
				dataType:"json",
				success(result){
					//开始处理所有者下拉框
					var html = '<option></option>';
					$.each(result.userList,function (i,n) {
						html+='<option value="'+n.id+'">'+n.name+'</option>'
					})
					$("#edit-owner").html(html);
					$("#edit-owner").val(result.contacts.owner);
					//处理其他信息
					$("#edit-source").val(result.contacts.source);
					$("#edit-fullname").val(result.contacts.fullname);
					$("#edit-appellation").val(result.contacts.appellation);
					$("#edit-job").val(result.contacts.job);
					$("#edit-mphone").val(result.contacts.mphone);
					$("#edit-email").val(result.contacts.email);
					$("#edit-birth").val(result.contacts.birth);
					$("#edit-customer").val(result.contacts.customerId);
					$("#edit-description").val(result.contacts.description);
					$("#edit-contactSummary").val(result.contacts.contactSummary);
					$("#edit-nextContactTime").val(result.contacts.nextContactTime);
					$("#edit-address").val(result.contacts.address);
					$("#editContactsModal").modal("show");
				}
			})

		})

		//为更新按钮绑定事件
		$("#updateBtn").click(function(){
			$.ajax({
				url:"workbench/Contacts/updateContacts.do",
				type:"post",
				data:{
					id:$("input[name=xz]:checked").val(),
					owner:$("#edit-owner").val(),
					source:$("#edit-source").val(),
					fullname:$("#edit-fullname").val(),
					appellation:$("#edit-appellation").val(),
					job:$("#edit-job").val(),
					mphone:$("#edit-mphone").val(),
					email:$("#edit-email").val(),
					birth:$("#edit-birth").val(),
					customerId:$("#edit-customer").val(),
					description:$("#edit-description").val(),
					contactSummary:$("#edit-contactSummary").val(),
					nextContactTime:$("#edit-nextContactTime").val(),
					address:$("#edit-address").val(),
				},
				dataType:"json",
				success(result){
					if(result.success){
						alert("更新成功！");
						pageList($("#contactsPage").bs_pagination('getOption', 'currentPage'),
								$("#contactsPage").bs_pagination('getOption', 'rowsPerPage'));
						$("#editContactsModal").modal("hide");
					}else{
						alert("更新失败！");
					}
				}
			})
		})

		//为删除按钮绑定事件
		$("#deleteBtn").click(function () {
			if($("input[name=xz]:checked").length==0){
				alert("至少选择一个联系人进行删除！");
				return;
			}
			$xz = $("input[name=xz]:checked")
			if(confirm("确认删除所选客户吗？")) {
				var param = ''
				$.each($xz, function (i, n) {
					param += 'id=' + $(n).val()
					if (i < $xz.length - 1) {
						param += '&'
					}
				})
				$.ajax({
					url:"workbench/Contacts/deleteContact.do",
					type:"post",
					data:param,
					dataType:"json",
					success(result){
						if(result.success){
							alert("删除成功！");
							pageList(1,$("#contactsPage").bs_pagination('getOption', 'rowsPerPage'));
						}else{
							alert("删除失败！");
						}
					}
				})
			}
		})

		//全选和全不选
		$("#qx").click(function () {
			$("input[name=xz]").prop("checked",this.checked)
		})
		//动态生成的元素绑定事件:$(需要绑定元素的有效的外层元素).on(绑定事件的方式,需要绑定的元素的jquery对象,回调函数)
		$("#tBody").on("click",$("input[name=xz]"),function () {
			if($("input[name=xz]:checked").length==$("input[name=xz]").length){
				$("#qx").prop("checked",true);
			}else{
				$("#qx").prop("checked",false);
			}
		})

		pageList(1,2);





	});

	function pageList(pageNo,pageSize) {

		$("#qx").prop("checked",false);


		//把隐藏域的值重新赋给搜索框
		$("#search-owner").val($("#hidden-owner").val());
		$("#search-fullname").val($("#hidden-fullname").val());
		$("#search-customer").val($("#hidden-customer").val());
		$("#search-source").val($("#hidden-source").val());
		$("#search-birth").val($("#hidden-birth").val());


		$.ajax({
			url:"workbench/Contacts/pageList.do",
			type:"get",
			data:{
				owner:$("#search-owner").val(),
				fullname:$("#search-fullname").val(),
				customer:$("#search-customer").val(),
				source:$("#search-source").val(),
				birth:$("#search-birth").val(),
				pageNo:pageNo,
				pageSize:pageSize

			},
			dataType:"json",
			success(result){
				var html = ''
				$.each(result.dataList,function (i,n) {
					html+='<tr>';
					html+='<td><input type="checkbox" name="xz" value="'+n.id+'"/></td>';
					html+='<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/Contacts/getDetail.do?id='+n.id+'\';">'+n.fullname+'</a></td>';
					html+='<td>'+n.customerId+'</td>';
					html+='<td>'+n.owner+'</td>';
					html+='<td>'+n.source+'</td>';
					html+='<td>'+n.birth+'</td>';
					html+='</tr>';
				})
				$("#tBody").html(html);

				//总页数
				var totalPages = Math.ceil(result.total/pageSize);

				//数据处理完毕后，结合分页查询，对前端展现分页信息
				$("#contactsPage").bs_pagination({
					currentPage: pageNo, // 页码
					rowsPerPage: pageSize, // 每页显示的记录条数
					maxRowsPerPage: 20, // 每页最多显示的记录条数
					totalPages: totalPages, // 总页数
					totalRows: result.total, // 总记录条数

					visiblePageLinks: 5, // 显示几个卡片

					showGoToPage: true,
					showRowsPerPage: true,
					showRowsInfo: true,
					showRowsDefaultInfo: true,
					//该回调函数是在，点击分页组件的时候触发的
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
	<input type="hidden" id="hidden-owner">
	<input type="hidden" id="hidden-fullname">
	<input type="hidden" id="hidden-customer">
	<input type="hidden" id="hidden-source">
	<input type="hidden" id="hidden-birth">

	
	<!-- 创建联系人的模态窗口 -->
	<div class="modal fade" id="createContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" onclick="$('#createContactsModal').modal('hide');">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabelx">创建联系人</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form" id="addContactsForm">

						<div class="form-group">
							<label for="create-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">
									<option></option>>
								</select>
							</div>
							<label for="create-source" class="col-sm-2 control-label">来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-source">
								  <option></option>
								  <c:forEach items="${source}" var="a">
									  <option value="${a.value}">${a.text}</option>
								  </c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-fullname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-fullname">
							</div>
							<label for="create-appellation" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-appellation">
								  <option></option>
									<c:forEach items="${appellation}" var="a">
										<option value="${a.value}">${a.text}</option>
									</c:forEach>
								</select>
							</div>
							
						</div>
						
						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job">
							</div>
							<label for="create-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone">
							</div>
						</div>
						
						<div class="form-group" style="position: relative;">
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
							<label for="create-birth" class="col-sm-2 control-label">生日</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-birth" readonly>
							</div>
						</div>
						
						<div class="form-group" style="position: relative;">
							<label for="create-customerName" class="col-sm-2 control-label">客户名称</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-customerName" placeholder="支持自动补全，输入客户不存在则新建">
							</div>
						</div>
						
						<div class="form-group" style="position: relative;">
							<label for="create-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control time" id="create-nextContactTime" readonly>
								</div>
							</div>
						</div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address"></textarea>
                                </div>
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
	
	<!-- 修改联系人的模态窗口 -->
	<div class="modal fade" id="editContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">修改联系人</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="edit-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-owner">
								  <%--所有者--%>
								</select>
							</div>
							<label for="edit-source" class="col-sm-2 control-label">来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-source">
								  <option></option>
								  <c:forEach var="a" items="${source}">
									  <option value="${a.value}">${a.text}</option>
								  </c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-fullname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-fullname" >
							</div>
							<label for="edit-appellation" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-appellation">
								  <option></option>
									<c:forEach var="a" items="${appellation}">
										<option value="${a.value}">${a.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job" >
							</div>
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone" >
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email" >
							</div>
							<label for="edit-birth" class="col-sm-2 control-label">生日</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-birth" readonly>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-customer" class="col-sm-2 control-label">所属公司</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-customer" placeholder="支持自动补全，输入客户不存在则新建">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control time" id="edit-nextContactTime" readonly>
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address"></textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" id="updateBtn" class="btn btn-primary" >更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>联系人列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
						<select class="form-control" id="search-owner">
							<%--查询框的所有者--%>

						</select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">姓名</div>
				      <input class="form-control" type="text" id="search-fullname">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所属公司</div>
				      <input class="form-control" type="text" id="search-customer">
				    </div>
				  </div>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">来源</div>
				      <select class="form-control" id="search-source">
						  <option></option>
						  <c:forEach items="${source}" var="a">
							  <option value="${a.value}">${a.text}</option>
						  </c:forEach>
						</select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">生日</div>
				      <input class="form-control time" type="text" id="search-birth" readonly>
				    </div>
				  </div>
				  
				  <button type="button" id="searchBtn" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="addBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 20px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="qx" /></td>
							<td>姓名</td>
							<td>客户名称</td>
							<td>所有者</td>
							<td>来源</td>
							<td>生日</td>
						</tr>
					</thead>
					<tbody id="tBody">
						<%--<tr>
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/contacts/detail.jsp';">马云</a></td>
							<td>阿里巴巴</td>
							<td>张三</td>
							<td>广告</td>
							<td>1977-11-11</td>
						</tr>
                        <tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/contacts/detail.jsp';">马化腾</a></td>
                            <td>腾讯</td>
                            <td>张三</td>
                            <td>广告</td>
                            <td>1977-11-11</td>
                        </tr>--%>
					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 10px;">

				<div id="contactsPage"></div>
			</div>
			
		</div>
		
	</div>
</body>
</html>