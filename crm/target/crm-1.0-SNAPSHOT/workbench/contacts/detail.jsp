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

		//日历控件
		$(".time").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "bottom-left"
		});



		//为修改按钮绑定事件
		$("#editBtn").click(function(){

			$.ajax({
				url:"workbench/Contacts/getUserListAndContacts.do",
				type:"get",
				data:{
					id:"${requestScope.contacts.id}"
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
	});

		//为更新按钮绑定事件
		$("#updateBtn").click(function(){
			$.ajax({
				url:"workbench/Contacts/updateContactsInDetail.do",
				type:"post",
				data:{
					id:"${requestScope.contacts.id}",
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
						//更新页面
						$("#DBT").text(result.contacts.fullname);
						$("#GS").html('<font color="#8b0000">'+result.contacts.customerId+'</font>');
						$("#SYZ").text(result.contacts.owner);
						$("#LY").text(result.contacts.source);
						$("#GSMC").text(result.contacts.customerId);
						$("#XM").text(result.contacts.fullname);
						$("#YX").text(result.contacts.email);
						$("#SJ").text(result.contacts.mphone);
						$("#ZW").text(result.contacts.job);
						$("#SR").text(result.contacts.birth);
						$("#CJZ").text(result.contacts.createby);
						$("#CJSJ").text(result.contacts.createTime);
						$("#XGZ").text(result.contacts.editBy);
						$("#XGSJ").text(result.contacts.editTime);
						$("#MS").text(result.contacts.description);
						$("#LXJY").text(result.contacts.contactSummary);
						$("#XCLXSJ").text(result.contacts.nextContactTime);
						$("#XXDZ").text(result.contacts.address);
						$("#editContactsModal").modal("hide");
					}else{
						alert("更新失败！");
					}
				}
			})
		})

		//为删除按钮绑定事件
		$("#deleteBtn").click(function(){
			$.ajax({
				url:"workbench/Contacts/deleteContact.do",
				type:"get",
				data:{
					id:"${requestScope.contacts.id}"
				},
				dataType:"json",
				success(result){
					if(result.success){
						alert("删除成功！");
						location.href="workbench/contacts/index.jsp";
					}else{
						alert("删除失败！");
					}
				}
			})
		})


		//显示修改和删除备注的图标
		$("#remarkBody").on("mouseover",".remarkDiv",function(){
			$(this).children("div").children("div").show();
		})
		$("#remarkBody").on("mouseout",".remarkDiv",function(){
			$(this).children("div").children("div").hide();
		})

		//为更新备注按钮添加事件
		$("#updateRemarkBtn").click(function () {
			var id = $("#remarkId").val()
			$.ajax({
				url:"workbench/Contacts/updateRemark.do",
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
						$("#editContactsRemarkModal").modal("hide");

					}else{
						alert("修改备注失败");
					}
				}
			})
			$("#noteContent").val("");
			$("#editRemarkModal").modal("hide");
		})

		//为保存按钮添加时间
		$("#saveBtn").click(function () {
			$.ajax({
				url:"workbench/Contacts/addRemark.do",
				type:"get",
				data:{
					noteContent:$("#remark").val(),
					customerId:"${requestScope.contacts.id}"
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
						html+='<font color="gray">联系人</font> <font color="gray">-</font> <b>${requestScope.contacts.fullname}</b> <small style="color: gray;" id="s'+result.remark.id+'"> '+result.remark.createTime+' 由 '+result.remark.createBy+'</small>'
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

		showRemarkList();
	})

	function showRemarkList() {
		$.ajax({
			url:"workbench/Contacts/showRemarkList.do",
			type:"get",
			data:{
				contactsId:"${requestScope.contacts.id}"
			},
			dataType: "json",
			success(result) {

				var html = "";
				$.each(result,function (i,n) {

					html+='<div id="'+n.id+'" class="remarkDiv" style="height: 60px;">';
					html+='<img title="'+n.createBy+'" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
					html+='<div style="position: relative; top: -40px; left: 40px;" >';
					html+='<h5 id="e'+n.id+'">'+n.noteContent+'</h5>';
					html+='<font color="gray">联系人</font> <font color="gray">-</font> <b>${requestScope.contacts.fullname}</b> <small style="color: gray;" id="s'+n.id+'"> '+(n.editFlag==0?n.createTime:n.editTime)+' 由 '+(n.editFlag==0? n.createBy:n.editBy)+'</small>'
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


	//打开修改备注模态窗口铺数据
	function updateRemark(id) {
		$("#remarkId").val(id);
		$("#noteContent").val($("#e"+id).text());
		$("#editContactsRemarkModal").modal("show");
	}

	//删除备注
	function deleteRemark(id) {
		$.ajax({
			url:"workbench/Contacts/deleteRemark.do",
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



</script>

</head>
<body>

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

<div class="modal fade" id="editContactsRemarkModal" role="dialog">
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
	


	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3 id="DBT">${requestScope.contacts.fullname} </h3><span id="GS" > <font color="#8b0000">${requestScope.contacts.customerId}</font> </span>
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
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="SYZ">${requestScope.contacts.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">来源</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="LY">${requestScope.contacts.source}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">公司名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="GSMC">${requestScope.contacts.customerId}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">姓名</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="XM">${requestScope.contacts.fullname}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">邮箱</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="YX">${requestScope.contacts.email}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">手机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="SJ">${requestScope.contacts.mphone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">职位</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="ZW">${requestScope.contacts.job}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">生日</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="SR">&nbsp;${requestScope.contacts.birth}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="CJZ">${requestScope.contacts.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;" id="CJSJ">${requestScope.contacts.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="XGZ">${requestScope.contacts.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;" id="XGSJ">${requestScope.contacts.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b id="MS">
					${requestScope.contacts.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">联系纪要</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b id="LXJY">
					${requestScope.contacts.contactSummary}&nbsp;
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">下次联系时间</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="XCLXSJ">${requestScope.contacts.nextContactTime}&nbsp;</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 90px;">
            <div style="width: 300px; color: gray;">详细地址</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b id="XXDZ">
					${requestScope.contacts.address}
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
	</div>
	<!-- 备注 -->
	<div style="position: relative; top: 20px; left: 40px;" id="remarkBody">
		<div class="page-header">
			<h4>备注</h4>
		</div>
		

		
		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button type="button" class="btn btn-primary" id="saveBtn">保存</button>
				</p>
			</form>
		</div>
	</div>

	<div style="height: 200px;"></div>
</body>
</html>