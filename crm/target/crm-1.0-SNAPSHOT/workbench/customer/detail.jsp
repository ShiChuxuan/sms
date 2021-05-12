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
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>

<script type="text/javascript">

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;
	
	$(function(){
		$("#remark").focus(function(){
			if(cancelAndSaveBtnDefault){
				//设置remarkDiv的高度为130px
				$("#remarkDiv").css("height","130px");
				//显示
				$("#cancelAndSaveBtn").show("2000");
				cancelAndSaveBtnDefault = false;
			}
		});
		
		$("#cancelBtn").click(function(){
			//显示
			$("#cancelAndSaveBtn").hide();
			//设置remarkDiv的高度为130px
			$("#remarkDiv").css("height","90px");
			cancelAndSaveBtnDefault = true;
		});
		
		$(".remarkDiv").mouseover(function(){
			$(this).children("div").children("div").show();
		});
		
		$(".remarkDiv").mouseout(function(){
			$(this).children("div").children("div").hide();
		});
		
		$(".myHref").mouseover(function(){
			$(this).children("span").css("color","red");
		});
		
		$(".myHref").mouseout(function(){
			$(this).children("span").css("color","#E6E6E6");
		});
		//以上都是动画效果

		//日历控件
		$(".time").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "top-left"
		});


		//为修改按钮绑定事件
		$("#editBtn").click(function () {

			$.ajax({
				url:"workbench/Customer/getUserListAndCustomer.do",
				type:"get",
				data:{
					id:"${requestScope.customer.id}"
				},
				dataType:"json",
				success(result){
					//处理所有这下拉框
					var html = '';
					html += '<option></option>'
					$.each(result.userList,function (i,n) {
						html += '<option value="'+n.id+'">'+n.name+'</option>'
					})
					$("#edit-owner").html(html);
					$("#edit-owner").val(result.customer.owner)
					//处理其他信息
					$("#edit-name").val(result.customer.name);
					$("#edit-website").val(result.customer.website);
					$("#edit-phone").val(result.customer.phone);
					$("#edit-description").val(result.customer.description);
					$("#edit-contactSummary").val(result.customer.contactSummary);
					$("#edit-nextContactTime").val(result.customer.nextContactTime);
					$("#edit-address").val(result.customer.address);

					$("#editCustomerModal").modal("show");
				}
			})
		})

		//为更新按钮绑定事件
		$("#updateBtn").click(function(){
			$.ajax({
				url:"workbench/Customer/updateCustomerInDetail.do",
				type:"get",
				data:{
					id:"${requestScope.customer.id}",
					owner:$("#edit-owner").val(),
					name:$("#edit-name").val(),
					website:$("#edit-website").val(),
					phone:$("#edit-phone").val(),
					description:$("#edit-description").val(),
					contactSummary:$("#edit-contactSummary").val(),
					nextContactTime:$("#edit-nextContactTime").val(),
					address:$("#edit-address").val()
				},
				dataType:"json",
				success(result){
					if(result.success){
						alert("更新成功");
						//更新页面
						$("#DBT").text(result.customer.name);
						$("#WZ").text(result.customer.website);
						$("#SYZ").text(result.customer.owner);
						$("#MC").text(result.customer.name);
						$("#GSWZ").text(result.customer.website);
						$("#GSZJ").text(result.customer.phone);
						$("#CJZ").text(result.customer.createBy);
						$("#CJSJ").text(result.customer.createTime);
						$("#XGZ").text(result.customer.editBy);
						$("#XGSJ").text(result.customer.editTime);
						$("#LXJY").text(result.customer.contactSummary);
						$("#XCLXSJ").text(result.customer.nextContactTime);
						$("#XXDZ").text(result.customer.address);

						$("#editCustomerModal").modal("hide");
					}else{
						alert("更新失败");
					}
				}
			})
		})

		//为删除按钮绑定事件
		$("#deleteBtn").click(function () {
				if(confirm("确认删除该客户吗？")){
					$.ajax({
						url:"workbench/Customer/deleteCustomer.do",
						type:"post",
						data:{
							id:"${requestScope.customer.id}"
						},
						dataType:"json",
						success(result){
							if(result.success){
								alert("删除成功！");
								location.href="workbench/customer/index.jsp";
							}else{
								alert("删除失败！");
							}
						}
					})
				}
		})





		//显示修改和删除备注的图标
		$("#remarkBody").on("mouseover",".remarkDiv",function(){
			$(this).children("div").children("div").show();
		})
		$("#remarkBody").on("mouseout",".remarkDiv",function(){
			$(this).children("div").children("div").hide();
		})


		//为保存按钮添加时间
		$("#saveBtn").click(function () {
			$.ajax({
				url:"workbench/Customer/addRemark.do",
				type:"get",
				data:{
					noteContent:$("#remark").val(),
					customerId:"${requestScope.customer.id}"
				},
				dataType:"json",
				success(result){
					if(result.success){
						alert("添加成功");
						var html="";
						html+='<div id="'+result.remark.id+'" class="remarkDiv" style="height: 60px;">';
						html+='<img title="'+result.remark.createBy+'" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
						html+='<div style="position: relative; top: -40px; left: 40px;" >';
						html+='<h5 id="e'+result.remark.id+'">'+result.remark.noteContent+'</h5>';
						html+='<font color="gray">订单</font> <font color="gray">-</font> <b>${requestScope.good.name}</b> <small style="color: gray;" id="s'+result.remark.id+'"> '+result.remark.createTime+' 由 '+result.remark.createBy+'</small>'
						html+='<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
						html+='<a class="myHref" href="javascript:void(0);" onclick="updateRemark(\''+result.remark.id+'\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color:blue;"></span></a>';
						html+='&nbsp;&nbsp;&nbsp;&nbsp;';
						html+='<a class="myHref" href="javascript:void(0);" onclick="deleteRemark(\''+result.remark.id+'\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color:red;"></span></a>';
						html+='</div>';
						html+='</div>';
						html+='</div>';
						$("#remarkDiv").before(html);
						$("#remark").val("");
					}else{
						alert("添加失败")
					}
				}
			})
		})

		//为更新备注按钮添加事件
		$("#updateRemarkBtn").click(function () {
			var id = $("#remarkId").val()
			$.ajax({
				url:"workbench/Customer/updateRemark.do",
				type:"get",
				data:{
					id:id,
					noteContent:$.trim($("#noteContent").val())
				},
				dataType:"json",
				success(result){
					if(result.success==true){
						//修改备注成功后
						//修改div中相应的信息，需要更新的内容有noteContent,editTime,editBy
						$("#e"+id).html(result.remark.noteContent);
						$("#s"+id).html(result.remark.editTime+' 由 '+result.remark.editBy);
						$("#editCustomerRemarkModal").modal("hide");

					}else{
						alert("修改备注失败");
					}
				}
			})
			$("#noteContent").val("");
			$("#editRemarkModal").modal("hide");
		})


		//为新建联系人组件绑定事件
		$("#createContactBtn").click(function () {
			$.ajax({
				url:"workbench/Customer/getUserList.do",
				type:"get",
				dataType:"json",
				success(result){
					var html = '';
					$.each(result,function (i,n) {
						html += '<option value="'+n.id+'">'+n.name+'</option>'
					})
					$("#create-owner").html(html);
					$("#create-owner").val("${sessionScope.user.id}");
					$("#createContactsModal").modal("show");
				}
			})
		})

		//为创建联系人模态窗口的保存按钮绑定事件
		$("#saveContactBtn").click(function () {
			$.ajax({
				url:"workbench/Customer/addContact.do",
				type:"get",
				data:{
					owner: $("#create-owner").val(),
					source:$("#create-source").val(),
					fullname:$("#create-fullname").val(),
					appellation:$("#create-appellation").val(),
					job:$("#create-job").val(),
					mphone:$("#create-mphone").val(),
					email:$("#create-email").val(),
					birth:$("#create-birth").val(),
					description:$("#create-description").val(),
					contactSummary:$("#create-contactSummary").val(),
					nextContactTime:$("#create-nextContactTime").val(),
					address:$("#create-address").val(),
					CustomerId:$("#create-company").val()

				},
				dataType:"json",
				success(result){
					if(result.success){
						showContactList();
						$("#createContactsModal").modal("hide");
					}
				}

			})
		})


		//关联商品组件绑定事件
		$("#relate").click(function () {
			$.ajax({
				url:"workbench/Customer/getGoodListByNameAndNotByCustomerId",
				type:"get",
				data:{
					name:$("#search-name").val(),
					customerId:"${requestScope.order.id}"
				},
				dataType:"json",
				success(result){
					var html = "";
					$.each(result,function (i,n) {
						html+='<tr>';
						html+='<td><input type="checkbox" name="xz" value="'+n.id+'"/></td>';
						html+='<td>'+n.name+'</td>'
						html+='<td>'+n.sid+'</td>';
						html+='<td>'+n.price+'</td>';
						html+='<td>'+n.amount+'</td>';
						html+='</tr>';
					})
					$("#searchBody").html(html);
					$("#bundModal").modal("show");
				}
			})
			return false;
		})


		//为搜索框绑定事件
		$("#search-name").keydown(function (event) {
			if(event.keyCode==13){
				$.ajax({
					url:"workbench/Customer/getGoodListByNameAndNotByCustomerId",
					type:"get",
					data:{
						name:$("#search-name").val(),
						customerId:"${requestScope.customer.id}"
					},
					dataType:"json",
					success(result){
						var html = "";
						$.each(result,function (i,n) {
							html+='<tr>';
							html+='<td><input type="checkbox" name="xz" value="'+n.id+'"/></td>';
							html+='<td>'+n.name+'</td>'
							html+='<td>'+n.sid+'</td>';
							html+='<td>'+n.price+'</td>';
							html+='<td>'+n.amount+'</td>';
							html+='</tr>';
						})
						$("#searchBody").html(html)
					}
				})
				//展现完列表一户，记得将模态窗口的默认回车事件禁用
				return false;
			}
		})


		//全选和全不选
		$("#qx").click(function () {
			$("input[name=xz]").prop("checked",this.checked)
		})
		//动态生成的元素绑定事件:$(需要绑定元素的有效的外层元素).on(绑定事件的方式,需要绑定的元素的jquery对象,回调函数)
		$("#searchBody").on("click",$("input[name=xz]"),function () {
			if($("input[name=xz]:checked").length==$("input[name=xz]").length){
				$("#qx").prop("checked",true);
			}else{
				$("#qx").prop("checked",false);
			}
		})


		//关联商品
		$("#relateBtn").click(function () {
			var $xz= $("input[name=xz]:checked");
			var param = "";
			$.each($xz,function (i,n) {
				param +="id=" +$(n).val();

				if(i<$xz.length-1){
					param +="&";
				}
			})
			param+="&customerId="+"${requestScope.customer.id}"
			$.ajax({
				url:"workbench/Customer/relate.do",
				type:"get",
				data:param,
				dataType:"json",
				success(result){
					if(result.success){
						alert("关联成功");
						showGoodList();
						$("#bundModal").modal("hide");
					}else{
						alert("关联失败");
					}
				}
			})
		})



		//铺备注数据
		showRemarkList();

		//铺交易列表数据
		showTranList();

		//铺联系人列表数据
		showContactList();

		//铺商品数据
		showGoodList();
	});

	function showRemarkList() {
		$.ajax({
			url:"workbench/Customer/showRemarkList.do",
			type:"get",
			data:{
				customerId:"${requestScope.customer.id}"
			},
			dataType: "json",
			success(result) {

				var html = "";
				$.each(result,function (i,n) {

					html+='<div id="'+n.id+'" class="remarkDiv" style="height: 60px;">';
					html+='<img title="'+n.createBy+'" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
					html+='<div style="position: relative; top: -40px; left: 40px;" >';
					html+='<h5 id="e'+n.id+'">'+n.noteContent+'</h5>';
					html+='<font color="gray">订单</font> <font color="gray">-</font> <b>${requestScope.order.fullname}</b> <small style="color: gray;" id="s'+n.id+'"> '+(n.editFlag==0?n.createTime:n.editTime)+' 由 '+(n.editFlag==0? n.createBy:n.editBy)+'</small>'
					html+='<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
					html+='<a class="myHref" href="javascript:void(0);" onclick="updateRemark(\''+n.id+'\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color:blue;"></span></a>';
					html+='&nbsp;&nbsp;&nbsp;&nbsp;';
					html+='<a class="myHref" href="javascript:void(0);" onclick="deleteRemark(\''+n.id+'\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color:red;"></span></a>';
					html+='</div>';
					html+='</div>';
					html+='</div>';

				})
				$("#remarkDiv").before(html);
			}

		})
	}

	function showTranList(){


		$.ajax({
			url:"workbench/Customer/showTranList.do",
			type:"get",
			data:{
				customerId:"${requestScope.customer.id}"
			},
			dataType:"json",
			success(result){
				var html = '';
				$.each(result,function (i,n) {
					html+='<tr>';
					html+='<td><a href="workbench/transaction/detail.jsp" style="text-decoration: none;">'+n.name+'</a></td>';
					html+='<td>'+n.money+'</td>';
					html+='<td>'+n.stage+'</td>';
					html+='<td>'+n.expectedDate+'</td>';
					html+='<td>'+n.type+'</td>';
					html+='<td><a href="javascript:void(0);" style="text-decoration: none;" onclick="deleteTran(\''+n.id+'\')"><span class="glyphicon glyphicon-remove"></span>删除</a></td>';
					html+='</tr>';
				})
				$("#tranBody").html(html);

			}
		})
	}

	function showContactList() {
		$.ajax({
			url:"workbench/Customer/showContactList.do",
			type:"get",
			data:{
				CustomerId:"${requestScope.customer.id}"
			},
			dataType:"json",
			success(result){
				var html = '';
				$.each(result,function (i,n) {
					html+= '<tr>';
					html+= '<td><a href="workbench/contacts/detail.jsp" style="text-decoration: none;">'+n.fullname+'</a></td>';
					html+= '<td>'+n.email+'</td>';
					html+= '<td>'+n.mphone+'</td>';
					html+= '<td><a href="javascript:void(0);" onclick="deleteContact(\''+n.id+'\')" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a></td>';
					html+= '</tr>';
				})
				$("#contactBody").html(html);

			}
		})
	}

	function showGoodList() {
		$.ajax({
			url:"workbench/Customer/getGoodListByCustomerId.do",
			type:"get",
			data:{
				customerId:"${requestScope.customer.id}"
			},
			dataType:"json",
			success(result){
				var html = "";
				$.each(result,function (i,n) {
					html+='<tr>';
					html+='<td>'+n.name+'</td>';
					html+='<td>'+n.sid+'</td>';
					html+='<td>'+n.price+'</td>';
					html+='<td>'+n.amount+'</td>';
					html+='<td><a href="javascript:void(0);" onclick="unbund(\''+n.id+'\')" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>';
					html+='</tr>';
				})
				$("#goodBody").html(html)
			}
		})
	}


	//打开修改备注模态窗口铺数据
	function updateRemark(id) {
		$("#remarkId").val(id);
		$("#noteContent").val($("#e"+id).text());
		$("#editCustomerRemarkModal").modal("show");
	}

	//删除备注
	function deleteRemark(id) {
		$.ajax({
			url:"workbench/Customer/deleteRemark.do",
			type:"get",
			data:{
				id:id
			},
			dataType:"json",
			success(result){
				if(result.success){
					//如果成功，刷新备注列表
					//这种做法不行，因为用的是before(),不是html(),不会清空前面有的内容
					//showRemarkList();

					//找到需要删除记录的div，将div移除掉
					alert("删除成功");
					$("#"+id).remove();
				}else{
					alert("删除失败");
				}
			}
		})

	}

	//删除交易
	function deleteTran(id) {
		$.ajax({
			url:"workbench/Customer/deleteTran.do",
			type:"get",
			data:{
				id:id
			},
			dataType:"json",
			success(result){
				if(result.success){
					alert("删除交易成功！！！");
					showTranList();
				}else{
					alert("删除失败！！！");
				}
			}
		})
	}

	//删除联系人
	function deleteContact(id) {
		$.ajax({
			url:"workbench/Customer/deleteContact.do",
			type:"get",
			data:{
				id:id
			},
			dataType:"json",
			success(result){
				if(result.success){
					alert("删除联系人成功！！！");
					showContactList();
				}else{
					alert("删除失败！！！");
				}
			}
		})
	}

	//解除关联
	function unbund(id) {
		$.ajax({
			url:"workbench/Customer/unbund.do",
			type:"get",
			data:{
				id:id
			},
			dataType:"json",
			success(result){
				if(result.success){
					showGoodList();
				}else{
					alert("解除失败！");
				}
			}
		})
	}


</script>

</head>
<body>

<!-- 修改订单备注的模态窗口 -->
<div class="modal fade" id="editCustomerRemarkModal" role="dialog">
	<%-- 备注的id --%>
	<input type="hidden" id="remarkId">
	<div class="modal-dialog" role="document" style="width: 40%;">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">
					<span aria-hidden="true">×</span>
				</button>
				<h4 class="modal-title" id="myModalLabel">修改备注</h4>
			</div>
			<div class="modal-body">
				<form class="form-horizontal" role="form">
					<div class="form-group">
						<label for="noteContent" class="col-sm-2 control-label">内容</label>
						<div class="col-sm-10" style="width: 81%;">
							<textarea class="form-control" rows="3" id="noteContent"></textarea>
						</div>
					</div>
				</form>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
				<button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
			</div>
		</div>
	</div>
</div>



	<!-- 创建联系人的模态窗口 -->
	<div class="modal fade" id="createContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" onclick="$('#createContactsModal').modal('hide');">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建联系人</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">
								  <%--所有者--%>
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
						
						<input type="hidden" id="create-company" value="${requestScope.customer.id}">
						
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
					<button type="button" class="btn btn-primary" id="saveContactBtn">保存</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 修改客户的模态窗口 -->
	<div class="modal fade" id="editCustomerModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">修改客户</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">

						<div class="form-group">
							<label for="edit-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-owner">

								</select>
							</div>
							<label for="edit-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-name" >
							</div>
						</div>

						<div class="form-group">
							<label for="edit-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-website" >
							</div>
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone" >
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
					<button type="button" class="btn btn-primary" id="updateBtn">更新</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 关联商品的模态窗口 -->
	<div class="modal fade" id="bundModal" role="dialog">
	<div class="modal-dialog" role="document" style="width: 80%;">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">
					<span aria-hidden="true">×</span>
				</button>
				<h4 class="modal-title">关联商品</h4>
			</div>
			<div class="modal-body">
				<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
					<form class="form-inline" role="form">
						<div class="form-group has-feedback">
							<input type="text" class="form-control" style="width: 300px;" id="search-name" placeholder="请输入商品名称，支持模糊查询">
							<span class="glyphicon glyphicon-search form-control-feedback"></span>
						</div>
					</form>
				</div>
				<table  class="table table-hover" style="width: 900px; position: relative;top: 10px;">
					<thead>
					<tr style="color: #B3B3B3;">
						<td><input type="checkbox" id="qx"/></td>
						<td>名称</td>
						<td>供应商</td>
						<td>售价</td>
						<td>库存</td>
					</tr>
					</thead>
					<tbody id="searchBody">
					<%--<tr>
                        <td><input type="checkbox"/></td>
                        <td>发传单</td>
                        <td>2020-10-10</td>
                        <td>2020-10-20</td>
                        <td>zhangsan</td>
                    </tr>
                    <tr>
                        <td><input type="checkbox"/></td>
                        <td>发传单</td>
                        <td>2020-10-10</td>
                        <td>2020-10-20</td>
                        <td>zhangsan</td>
                    </tr>--%>
					</tbody>
				</table>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
				<button type="button" class="btn btn-primary" id="relateBtn">关联</button>
			</div>
		</div>
	</div>
</div>






	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3 id="DBT">${requestScope.customer.name} </h3> <small><a href="${requestScope.customer.website}" target="_blank" id="WZ">${requestScope.customer.website}</a></small>
		</div>
		<div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
			<button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	
	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="SYS">${requestScope.customer.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="MC">${requestScope.customer.name}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">公司网站</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="GSWZ">${requestScope.customer.website}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">公司座机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="GSZj">${requestScope.customer.phone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="CJZ">${requestScope.customer.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;" id="CJSJ">${requestScope.customer.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="XGZ">${requestScope.customer.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;" id="XGSJ">${requestScope.customer.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 40px;">
            <div style="width: 300px; color: gray;">联系纪要</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b id="LXJY">
					${requestScope.customer.contactSummary}
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
        <div style="position: relative; left: 40px; height: 30px; top: 50px;">
            <div style="width: 300px; color: gray;">下次联系时间</div>
            <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="XCLXSJ">${requestScope.customer.nextContactTime}</b></div>
            <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
        </div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b id="MS">
					${requestScope.customer.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 70px;">
            <div style="width: 300px; color: gray;">详细地址</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b id="XXDZ">
					${requestScope.customer.address}
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
	</div>
	
	<!-- 备注 -->
	<div style="position: relative; top: 10px; left: 40px;" id="remarkBody">
		<div class="page-header">
			<h4>备注</h4>
		</div>


		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button type="button"  id="saveBtn" class="btn btn-primary">保存</button>
				</p>
			</form>
		</div>
	</div>
	
	<!-- 交易 -->
	<div>
		<div style="position: relative; top: 20px; left: 40px;">
			<div class="page-header">
				<h4>交易</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table id="activityTable2" class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>名称</td>
							<td>金额</td>
							<td>阶段</td>
							<td>预计成交日期</td>
							<td>类型</td>
							<td></td>
						</tr>
					</thead>
					<tbody id="tranBody">
						<%--交易！！！--%>
					</tbody>
				</table>
			</div>
			
			<div>
				<a href="workbench/transaction/save.jsp" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>新建交易</a>
			</div>
		</div>
	</div>
	
	<!-- 联系人 -->
	<div>
		<div style="position: relative; top: 20px; left: 40px;">
			<div class="page-header">
				<h4>联系人</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table id="activityTable" class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>名称</td>
							<td>邮箱</td>
							<td>手机</td>
							<td></td>
						</tr>
					</thead>
					<tbody id="contactBody">
						<%--<tr>
							<td><a href="contacts/detail.html" style="text-decoration: none;">李四</a></td>
							<td>lisi@bjpowernode.com</td>
							<td>13543645364</td>
							<td><a href="javascript:void(0);" data-toggle="modal" data-target="#removeContactsModal" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a></td>
						</tr>--%>
					</tbody>
				</table>
			</div>
			
			<div>
				<a href="javascript:void(0);" id="createContactBtn" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>新建联系人</a>
			</div>
		</div>
	</div>

<!-- 订购商品 -->
<div>
	<div style="position: relative; top: 60px; left: 40px;">
		<div class="page-header">
			<h4>订购商品</h4>
		</div>
		<div style="position: relative;top: 0px;">
			<table class="table table-hover" style="width: 900px;">
				<thead>
				<tr style="color: #B3B3B3;">
					<td>名称</td>
					<td>供应商</td>
					<td>售价</td>
					<td>库存</td>
				</tr>
				</thead>
				<tbody id="goodBody">
				<%--<tr>
                    <td>辛普劳1111</td>
                    <td>麦肯食品(哈尔滨)有限公司</td>
                    <td>11.11</td>
                    <td>1000</td>
                    <td>100</td>
                    <td><a href="javascript:void(0);"  style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>
                </tr>
                <tr>
                    <td>辛普劳222</td>
                    <td>麦肯食品(哈尔滨)有限公司</td>
                    <td>22.22</td>
                    <td>2000</td>
                    <td>200</td>
                    <td><a href="javascript:void(0);"  style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>
                </tr>--%>
				</tbody>
			</table>
		</div>

		<div>
			<a href="javascript:void(0);" id="relate" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>关联商品</a>
		</div>
	</div>
</div>



	<div style="height: 200px;"></div>
</body>
</html>