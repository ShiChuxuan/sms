<%@ page import="com.bjpowernode.crm.settings.domain.DicValue" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page import="com.bjpowernode.crm.workbench.domain.Tran" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + 	request.getServerPort() + request.getContextPath() + "/";
	//阶段的值
	List <DicValue> dvList = (List<DicValue>) application.getAttribute("stage");
    //阶段和可能性的关联关系
	Map<String,String>pMap = (Map<String,String>) application.getAttribute("pMap");

	//准备：前面正常阶段和后面丢失阶段的分界点下标
	int point = 0;
	for (int i = 0; i<dvList.size();i++){
		DicValue dicValue = dvList.get(i);
		//获得值
		String value = dicValue.getValue();
		//获得可能性
		String possibility = pMap.get(value);

		if("0".equals(possibility)){
			point = i;
			break;
		}

	}
%>
<html>
<head>
<meta charset="UTF-8">
<base href="<%=basePath%>">
<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />

<style type="text/css">
.mystage{
	font-size: 20px;
	vertical-align: middle;
	cursor: pointer;
}
.closingDate{
	font-size : 15px;
	cursor: pointer;
	vertical-align: middle;
}
</style>
	
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>
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
		/*以上都是动画效果*/

		//修改按钮
		$("#editBtn").click(function () {
			location.href = "workbench/Tran/getUserListAndTran.do?id="+"${requestScope.tran.id}";
		})

		//删除按钮
		$("#deleteBtn").click(function () {
			if(confirm("确认删除此交易吗？")){
				$.ajax({
					url:"workbench/Tran/deleteTran.do",
					type:"post",
					data:{
						id:"${requestScope.tran.id}"
					},
					dataType:"json",
					success(result){
						if(result.success){
							alert("删除成功！");
							location.href="workbench/transaction/index.jsp"
						}else{
							alert("删除失败！");
						}
					}
				})
			}
		})


		//订购商品
		$("#relate").click(function () {
			$("#orderGoodsModal").modal("show");
		})


		//订购商品页面关键代码
		$("#order-name").typeahead({
			source: function (query, process) {
				$.ajax({
					dataType:"json",
					type:"get",
					url:"workbench/Goods/getGoodsName.do",
					data:{"name":query},
					success:function (data) {
						process(data);
					}
				})
				},//source

			delay: 1000,

		}).change(function () {
			var current = $("#order-name").typeahead("getActive");
			if(current){
				$("#order-goodsId").val(current.id);
				$("#order-supplier").val(current.sid);
				$("#order-price").val(current.price);
				$("#order-amount2").val(current.amount);
			}
		});

		//保存订购商品按钮
		$("#saveBtn").click(function () {
			if(eval($("#order-amount1").val())>eval($("#order-amount2").val())){
				alert("订购数量超过库存数量！");
				return;
			}
			$.ajax({
				url:"workbench/Tran/orderGood.do",
				type:"get",
				data:{
					tranId:"${requestScope.tran.id}",
					goodId:$("#order-goodsId").val(),
					amount:$("#order-amount1").val(),
				},
				dataType:"json",
				success(result){
					if(result.success){
						alert("添加成功！");
						showGoodList();
						var orderGoodForm = $("#orderGoodForm")[0];
						orderGoodForm.reset();
						$("#orderGoodsModal").modal("hide");
					}else{
						alert("添加失败！");
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
				url:"workbench/Tran/updateRemark.do",
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
						$("#editTranRemarkModal").modal("hide");

					}else{
						alert("修改备注失败");
					}
				}
			})
			$("#noteContent").val("");
			$("#editRemarkModal").modal("hide");
		})


		//为保存备注按钮添加事件
		$("#saveRemarkBtn").click(function () {
			$.ajax({
				url:"workbench/Tran/addRemark.do",
				type:"get",
				data:{
					noteContent:$("#remark").val(),
					tranId:"${requestScope.tran.id}"
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

		//阶段提示框
		$(".mystage").popover({
            trigger:'manual',
            placement : 'bottom',
            html: 'true',
            animation: false
        }).on("mouseenter", function () {
                    var _this = this;
                    $(this).popover("show");
                    $(this).siblings(".popover").on("mouseleave", function () {
                        $(_this).popover('hide');
                    });
                }).on("mouseleave", function () {
                    var _this = this;
                    setTimeout(function () {
                        if (!$(".popover:hover").length) {
                            $(_this).popover("hide")
                        }
                    }, 100);
                });



		//展现订购商品列表
		showGoodList();

		//展现备注列表
		showRemarkList();

		//展现交易阶段列表
		showTranHistoryList();
	});

	//展现订购商品列表
	function showGoodList() {
		$.ajax({
			url:"workbench/Tran/showGoodList.do",
			type:"get",
			data:{
				id:"${requestScope.tran.id}"
			},
			dataType:"json",
			success(result){
				var html = '';
				$.each(result,function (i,n) {
					html+= '<tr>';
					html+= '<td>'+n.name+'</td>';
					html+= '<td>'+n.sid+'</td>';
					html+= '<td>'+n.price+'</td>';
					html+= '<td>'+n.amount+'</td>';
					html+= '<td>'+n.amount2+'</td>';
					html+='<td><a href="javascript:void(0);" onclick="unbund(\''+n.id+'\')" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a></td>';
					html+= '</tr>';
				})
				$("#goodBody").html(html);
			}

		})
	}

	//展现备注列表
	function showRemarkList() {
		$.ajax({
			url:"workbench/Tran/showRemarkList.do",
			type:"get",
			data:{
				tranId:"${requestScope.tran.id}"
			},
			dataType: "json",
			success(result) {

				var html = "";
				$.each(result,function (i,n) {

					html+='<div id="'+n.id+'" class="remarkDiv" style="height: 60px;">';
					html+='<img title="'+n.createBy+'" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
					html+='<div style="position: relative; top: -40px; left: 40px;" >';
					html+='<h5 id="e'+n.id+'">'+n.noteContent+'</h5>';
					html+='<font color="gray">交易</font> <font color="gray">-</font> <b>${requestScope.tran.name}</b> <small style="color: gray;" id="s'+n.id+'"> '+(n.editFlag==0?n.createTime:n.editTime)+' 由 '+(n.editFlag==0? n.createBy:n.editBy)+'</small>'
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

	//展现阶段历史列表
	function showTranHistoryList() {
		$.ajax({
			url:"workbench/Tran/showTranHistoryList.do",
			type:"get",
			data:{
				tranId:"${requestScope.tran.id}"
			},
			dataType:"json",
			success(result){
				var html = '';
				$.each(result,function (i,n) {
				    html+='<tr>';
					html+='<td>'+n.stage+'</td>';
					html+='<td>'+n.money+'</td>';
					html+='<td>'+n.possibility+'</td>';
					html+='<td>'+n.expectedDate+'</td>';
					html+='<td>'+n.createTime+'</td>';
					html+='<td>'+n.createBy+'</td>';
					html+='</tr>';
				})
				$("#historyBody").html(html);
			}
		})
	}

	//更新备注
	function updateRemark(id) {
		$("#remarkId").val(id);
		$("#noteContent").val($("#e"+id).text());
		$("#editTranRemarkModal").modal("show");
	}

	//删除备注
	function deleteRemark(id) {
		$.ajax({
			url:"workbench/Tran/deleteRemark.do",
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

	//删除订购商品
	function unbund(id) {
		alert("id:"+id);
		$.ajax({
			url:"workbench/Tran/unbund.do",
			type:"get",
			data:{
				id:id
			},
			dataType:"json",
			success(result){
				if(result.success){
					showGoodList();
				}else{
					alert("删除失败！")
				}
			}
		})
	}

	function changeStage(stage,i) {
		$.ajax({
			url:"workbench/Tran/changeStage.do",
			type:"get",
			data:{
				id:"${requestScope.tran.id}",
				stage:stage,
				money:"${requestScope.tran.money}",
				expectedDate:"${requestScope.tran.expectedDate}",
			},
			dataType:"json",
			success(result){
				if(result.success){
					//更新数据
					$("#JD").text(result.tran.stage);
					$("#KNX").text(result.tran.possibility);
					$("#XGZ").text(result.tran.editBy);
					$("#XGSJ").text(result.tran.editTime);

					showTranHistoryList();
					changeIcon(stage,i);
				}
				else{
					alert("更新失败！")
				}

			}
		})
	}

	function changeIcon(stage,i) {
		var currentStage = stage;

		var possibility = $("#KNX").text();

		var point = "<%=point%>";

		var index = i;

		//前七个全是黑圈，后两个是红叉或者黑叉
		if("0" == possibility){
			for(var a = 0;a<point;a++){
				//黑圈
				$("#"+a).removeClass();
				$("#"+a).addClass("glyphicon glyphicon-record mystage");
				$("#"+a).css("color","#000000")
			}

			for(var a = point;a<"<%=dvList.size()%>";a++){
				if(a==index){
					//红叉
					$("#"+a).removeClass();
					$("#"+a).addClass("glyphicon glyphicon-remove mystage");
					$("#"+a).css("color","#FF0000")
				}else{
					//黑叉
					$("#"+a).removeClass();
					$("#"+a).addClass("glyphicon glyphicon-remove mystage");
					$("#"+a).css("color","#000000")
				}

			}

		//后两个为黑叉，前七个为绿勾、绿标记、黑圈
		}else{
			for(var a = point;a<<%=dvList.size()%>;a++){
				//黑叉
				$("#"+a).removeClass();
				$("#"+a).addClass("glyphicon glyphicon-remove mystage");
				$("#"+a).css("color","#000000")
			}

			for(var a = 0;a<point;a++){
				if(a<index){
					//绿勾
					$("#"+a).removeClass();
					$("#"+a).addClass("glyphicon glyphicon-ok-circle mystage");
					$("#"+a).css("color","#90F790")

				}else if(a == index){
					//绿色标记
					$("#"+a).removeClass();
					$("#"+a).addClass("glyphicon glyphicon-map-marker mystage");
					$("#"+a).css("color","#90F790");
				}else{
					//黑圈
					$("#"+a).removeClass();
					$("#"+a).addClass("glyphicon glyphicon-record mystage");
					$("#"+a).css("color","#000000")
				}
			}

		}


	}

</script>

</head>


<body>
<!-- 订购商品的模态窗口 -->
<div class="modal fade" id="orderGoodsModal" role="dialog">
	<div class="modal-dialog" role="document" style="width: 85%;">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">
					<span aria-hidden="true">×</span>
				</button>
				<h4 class="modal-title" id="myModalLabel1">订购商品</h4>
			</div>
			<div class="modal-body">

				<form id="orderGoodForm" class="form-horizontal" role="form">

					<div class="form-group">
						<label for="order-name" class="col-sm-2 control-label">商品名称</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="order-name"  placeholder="请输入商品名称，支持模糊查询">
						</div>

						<label for="order-amount1" class="col-sm-2 control-label">订购数量</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="order-amount1">
						</div>

					</div>

					<div class="form-group">
						<label for="order-goodsId" class="col-sm-2 control-label">商品编号</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="order-goodsId" readonly>
						</div>
						<label for="order-supplier" class="col-sm-2 control-label">供应商</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="order-supplier" readonly>
						</div>
					</div>
					<div class="form-group">
						<label for="order-price" class="col-sm-2 control-label">商品售价</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control" id="order-price" readonly>
						</div>
						<label for="order-amount2" class="col-sm-2 control-label">库存数量</label>
						<div class="col-sm-10" style="width: 300px;">
							<input type="text" class="form-control time" id="order-amount2" readonly>
						</div>
					</div>
				</form>

			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
				<button type="button" id="saveBtn" class="btn btn-primary">保存</button>
			</div>
		</div>
	</div>
</div>

<!-- 修改订单备注的模态窗口 -->
<div class="modal fade" id="editTranRemarkModal" role="dialog">
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
			<h3>${requestScope.tran.customerId}-${requestScope.tran.name} <small>￥${requestScope.tran.money}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 250px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
			<button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>

	<!-- 阶段状态 -->
	<div style="position: relative; left: 40px; top: -50px;">
		阶段&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<%
			//取得当前阶段的可能性
			Tran tran = (Tran) request.getAttribute("tran");

			String currentStage = tran.getStage();
			String currentPossibility = tran.getPossibility();


			//判断当前阶段，如果为0说明前七个都是黑圈，后两个要么是红叉，要么是黑叉
			if("0".equals(currentPossibility)){
				for(int i = 0; i<dvList.size();i++){
					//遍历出来的每一个阶段
					DicValue dv = dvList.get(i);
					//取得值
					String listValue = dv.getValue();
					//取得阶段可能性
					String listPossibility = pMap.get(listValue);

					//说明是后两个
					if("0".equals(listPossibility)){
						if(currentStage.equals(listValue)){
							//----------------------------红叉----------------------------

		%>
		<span onclick="changeStage('<%=listValue%>','<%=i%>')" id="<%=i%>" class="glyphicon glyphicon-remove mystage" data-toggle="popover" data-placement="bottom" data-content="<%=dv.getText()%>" style="color: #FF0000"></span>
		-----------
		<%
						}else{
							//----------------------------黑叉----------------------------
		%>
		<span onclick="changeStage('<%=listValue%>','<%=i%>')" id="<%=i%>" class="glyphicon glyphicon-remove mystage" data-toggle="popover" data-placement="bottom" data-content="<%=dv.getText()%>"></span>
		-----------
		<%
						}

					//说明是前七个
					}else{
					//----------------------------黑圈----------------------------
		%>
		<span onclick="changeStage('<%=listValue%>','<%=i%>')" id="<%=i%>" class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="<%=dv.getText()%>" style="color: #000000;"></span>
		-----------
		<%
					}

				}


			//判断当前阶段，如果不为0说明后两个都是黑叉，前七个可能是绿勾、绿圈、黑圈
			}else{
				int index = 0;

				for (int i = 0; i<dvList.size();i++){
				  DicValue dicValue = dvList.get(i);
				  String   value = dicValue.getValue();
				  String   possibility = pMap.get(value);

				  if(currentPossibility.equals(possibility)){
				  	index = i;
				  }
				}


				for(int i = 0; i<dvList.size();i++){
					//遍历出来的每一个阶段
					DicValue dv = dvList.get(i);
					//取得值
					String listValue = dv.getValue();
					//取得阶段可能性
					String listPossibility = pMap.get(listValue);

					//说明是后两个
					if("0".equals(listPossibility)){

							//----------------------------黑叉----------------------------
		%>
		<span onclick="changeStage('<%=listValue%>','<%=i%>')" id="<%=i%>" class="glyphicon glyphicon-remove mystage" data-toggle="popover" data-placement="bottom" data-content="<%=dv.getText()%>"></span>
		-----------
		<%
						//说明是前七个
					}else{
						if(i<index){

							//----------------------------绿勾----------------------------
		%>
		<span onclick="changeStage('<%=listValue%>','<%=i%>')" id="<%=i%>" class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="<%=dv.getText()%>" style="color: #90F790;"></span>
		-----------
		<%
						}else if (i == index){

							//----------------------------绿色----------------------------
		%>
		<span onclick="changeStage('<%=listValue%>','<%=i%>')" id="<%=i%>" class="glyphicon glyphicon-map-marker mystage" data-toggle="popover" data-placement="bottom" data-content="<%=dv.getText()%>" style="color: #90F790;"></span>
		-----------
		<%

						}else{

							//----------------------------黑圈----------------------------
		%>
		<span onclick="changeStage('<%=listValue%>','<%=i%>')" id="<%=i%>" class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="<%=dv.getText()%>" style="color: #000000;"></span>
		-----------
		<%
						}

					}

				}
			}
		%>



		<%--<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="资质审查" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="需求分析" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="价值建议" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="确定决策者" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-map-marker mystage" data-toggle="popover" data-placement="bottom" data-content="提案/报价" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="谈判/复审"></span>
		-----------
		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="成交"></span>
		-----------
		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="丢失的线索"></span>
		-----------
		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="因竞争丢失关闭"></span>
		-------------%>
		<span class="closingDate">${requestScope.tran.expectedDate}</span>
	</div>
	
	<!-- 详细信息 -->
	<div style="position: relative; top: 0px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.tran.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">金额</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${requestScope.tran.money}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.tran.name}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">预计成交日期</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${requestScope.tran.expectedDate}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">客户名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.tran.customerId}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">阶段</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="JD">${requestScope.tran.stage}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">类型</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.tran.type}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">可能性</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="KNX">${requestScope.tran.possibility}%</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">来源</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${requestScope.tran.source}</b></div>
			&nbsp;&nbsp;&nbsp;
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -40px;"></div>

		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">联系人名称</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${requestScope.tran.contactsId}</b></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${requestScope.tran.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${requestScope.tran.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="XGZ">${requestScope.tran.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;" id="XGSJ">${requestScope.tran.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${requestScope.tran.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 90px;">
			<div style="width: 300px; color: gray;">联系纪要</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					&nbsp;${requestScope.tran.contactSummary}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 100px;">
			<div style="width: 300px; color: gray;">下次联系时间</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>&nbsp;${requestScope.tran.nextContactTime}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
	</div>
	
	<!-- 备注 -->
	<div style="position: relative; top: 100px; left: 40px;" id="remarkBody">
		<div class="page-header">
			<h4>备注</h4>
		</div>

		
		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button type="button" id="saveRemarkBtn" class="btn btn-primary">保存</button>
				</p>
			</form>
		</div>
	</div>

	<br>
	<br>
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
						<td>订购数量</td>
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
				<a href="javascript:void(0);" id="relate" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>添加商品</a>
			</div>
		</div>
	</div>






	<!-- 阶段历史 -->
	<div>
		<div style="position: relative; top: 100px; left: 40px;">
			<div class="page-header">
				<h4>阶段历史</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table id="activityTable" class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>阶段</td>
							<td>金额</td>
							<td>可能性</td>
							<td>预计成交日期</td>
							<td>创建时间</td>
							<td>创建人</td>
						</tr>
					</thead>
					<tbody id="historyBody">

					</tbody>
				</table>
			</div>
			
		</div>
	</div>
	
	<div style="height: 200px;"></div>
	
</body>
</html>