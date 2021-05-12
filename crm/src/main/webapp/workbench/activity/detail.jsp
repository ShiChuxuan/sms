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

		//以上都是动画效果

		//日历插件
		$(".time").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "bottom-left"
		});




		//编辑按钮
		//打开修改商品的模态窗口
		$("#editBtn").click(function () {
			$.ajax({
				url:"workbench/Goods/getSupplierListAndGood.do",
				type:"get",
				data:{
					id:"${requestScope.good.id}"
				},
				dataType:"json",
				success(result){
					//处理赞助商下拉框
					var html = '<option></option>'
					$.each(result.supplierList,function (i,n) {
						html+='<option value="'+n.id+'">'+n.name+'</option>'
					})
					$("#edit-goodSupplier").html(html);
					$("#edit-goodSupplier").val(result.good.sid);//默认选中

					//处理商品
					$("#edit-goodId").val(result.good.id);
					$("#edit-goodName").val(result.good.name);
					$("#edit-firstDate").val(result.good.firstDate);
					$("#edit-lastDate").val(result.good.lastDate);
					$("#edit-cost").val(result.good.cost);
					$("#edit-description").val(result.good.description);
					$("#edit-price").val(result.good.price);
					$("#edit-amount").val(result.good.amount);
				}
			})

			$("#editGoodModal").modal("show");
		})

		//修改商品
		$("#updateBtn").click(function () {
			$.ajax({
				url:"workbench/Goods/updateGoodInDetail.do",
				type:"get",
				data:{
					id:"${requestScope.good.id}",
					sid: $.trim($("#edit-goodSupplier").val()),
					name:$.trim($("#edit-goodName").val()),
					firstDate:$.trim($("#edit-firstDate").val()),
					lastDate:$.trim($("#edit-lastDate").val()),
					cost: $.trim($("#edit-cost").val()),
					price:$.trim($("#edit-price").val()),
					description:$.trim($("#edit-description").val()),
					amount:$.trim($("#edit-amount").val())
				},
				dataType:"json",
				success(result){
					if(result.success){
						alert("更新成功！");
						//更新页面
						$("#GYS").text(result.good.sid);
						$("#SPMC").text(result.good.name);
						$("#SCJHRQ").text(result.good.firstDate);
						$("#ZXJHRQ").text(result.good.lastDate);
						$("#CB").text(result.good.cost);
						$("#KZ").text(result.good.amount);
						$("#SJ").text(result.good.price);
						$("#XGZ").text(result.good.editBy);
						$("#XGSJ").text(result.good.editTime);
						$("#MS").text(result.good.description);
						$("#DBT").text(result.good.name);
						$("#editGoodModal").modal("hide");
					}else{
						alert("更新失败！");
					}
				}
			})

		})

		//删除商品
		$("#deleteBtn").click(function () {

			if(confirm("确认要删除所选的商品吗？")){

				$.ajax({
					url:"workbench/Goods/deleteGood.do",
					type:"get",
					data:{
						id:"${requestScope.good.id}"
					},
					dataType:"json",
					success(result){
						if(result.success){
							alert("删除成功");
							location.href='workbench/activity/index.jsp';
						}else{
							alert("删除失败");
						}
					}

				})
			}
		})

		//铺备注数据
		showRemarkList();

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
				url:"workbench/Goods/updateRemark.do",
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
						$("#editGoodRemarkModal").modal("hide");

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
				url:"workbench/Goods/addRemark.do",
				type:"get",
				data:{
					noteContent:$("#remark").val(),
					goodId:"${requestScope.good.id}"
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
						html+='<font color="gray">商品</font> <font color="gray">-</font> <b>${requestScope.good.name}</b> <small style="color: gray;" id="s'+result.remark.id+'"> '+result.remark.createTime+' 由 '+result.remark.createBy+'</small>'
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




	});

	function deleteRemark(id) {
		$.ajax({
			url:"workbench/Goods/deleteRemark.do",
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

	//打开模态窗口铺数据
	function updateRemark(id) {
		$("#remarkId").val(id);
		$("#noteContent").val($("#e"+id).text());
		$("#editGoodRemarkModal").modal("show");
	}



	function showRemarkList() {
		$.ajax({
			url:"workbench/Goods/showRemarkList.do",
			type:"get",
			data:{
				goodId:"${requestScope.good.id}"
			},
			dataType: "json",
			success(result) {

				var html = "";
				$.each(result,function (i,n) {

					html+='<div id="'+n.id+'" class="remarkDiv" style="height: 60px;">';
					html+='<img title="'+n.createBy+'" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
					html+='<div style="position: relative; top: -40px; left: 40px;" >';
					html+='<h5 id="e'+n.id+'">'+n.noteContent+'</h5>';
					html+='<font color="gray">商品</font> <font color="gray">-</font> <b>${requestScope.good.name}</b> <small style="color: gray;" id="s'+n.id+'"> '+(n.editFlag==0?n.createTime:n.editTime)+' 由 '+(n.editFlag==0? n.createBy:n.editBy)+'</small>'
					html+='<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
					html+='<a class="myHref" href="javascript:void(0);" onclick="updateRemark(\''+n.id+'\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color:blue;"></span></a>';
					html+='&nbsp;&nbsp;&nbsp;&nbsp;';
					html+='<a class="myHref" href="javascript:void(0);" onclick="deleteRemark(\''+n.id+'\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color:red;"></span></a>';
					html+='</div>';
					html+='</div>';
					html+='</div>';
					/*
					*   javascript:void(0);：
					*       将超链接禁用，只能以触发事件的形式来操作
					*
					*
					* */
					/*
					*       onclick="deleteRemark(\''+n.id+'\')"
					*       对于动态元素生成所触发的方法，参数必须套用在字符串当中
					*
					* */

				})
				$("#remarkDiv").before(html);
			}

		})
	}
	
</script>

</head>
<body>
	
	<!-- 修改商品备注的模态窗口 -->
	<div class="modal fade" id="editGoodRemarkModal" role="dialog">
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

	<!-- 修改商品的模态窗口 -->
	<div class="modal fade" id="editGoodModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改商品</h4>
				</div>
				<div class="modal-body">

					<form class="form-horizontal" role="form">

						<div class="form-group">
							<label for="edit-goodSupplier" class="col-sm-2 control-label">供应商<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-goodSupplier">
									<%--修改模态窗口的供应商--%>
								</select>
							</div>
							<label for="edit-goodName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-goodName">

								<input type="hidden" id="edit-goodId"> <%--商品id--%>
							</div>
						</div>

						<div class="form-group">
							<label for="edit-firstDate" class="col-sm-2 control-label">首次进货时间</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" readonly id="edit-firstDate">
							</div>
							<label for="edit-lastDate" class="col-sm-2 control-label">最新进货时间</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" readonly id="edit-lastDate">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost">
							</div>
							<label for="edit-cost" class="col-sm-2 control-label">售价</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-price">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">库存</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-amount">
							</div>
						</div>


						<div class="form-group">
							<label for="edit-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description"></textarea>
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

	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3 id="DBT">商品-${requestScope.good.name} <small></small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 250px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
			<button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	
	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;" >供应商</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;" ><b id="GYS">${requestScope.good.sid}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;" >商品名称</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;" ><b id="SPMC">${requestScope.good.name}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>

		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">首次进货日期</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;" ><b id="SCJHRQ">${requestScope.good.firstDate}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">最新进货日期</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="ZXJHRQ">${requestScope.good.lastDate}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">成本</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="CB">${requestScope.good.cost}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">库存</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="KZ">${requestScope.good.amount}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">售价</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="SJ">${requestScope.good.price}&nbsp;&nbsp;</b></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>

		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${requestScope.good.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${requestScope.good.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="XGZ">${requestScope.good.editBy}&nbsp;&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;" id="XGSJ">${requestScope.good.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b id="MS">
					${requestScope.good.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
	</div>
	
	<!-- 备注 -->
	<div style="position: relative; top: 30px; left: 40px;" id="remarkBody">
		<div class="page-header">
			<h4>备注</h4>
		</div>
		
<%--		<!-- 备注1 -->
		<div class="remarkDiv" style="height: 60px;">
			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>哎呦！</h5>
				<font color="gray">市场活动</font> <font color="gray">-</font> <b>发传单</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>
				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
				</div>
			</div>
		</div>
		
		<!-- 备注2 -->
		<div class="remarkDiv" style="height: 60px;">
			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>呵呵！</h5>
				<font color="gray">市场活动</font> <font color="gray">-</font> <b>发传单</b> <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>
				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
				</div>
			</div>
		</div>--%>
		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button id="saveBtn" type="button" class="btn btn-primary">保存</button>
				</p>
			</form>
		</div>
	</div>
	<div style="height: 200px;"></div>
</body>
</html>