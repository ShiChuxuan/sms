import com.bjpowernode.crm.settings.dao.UserDao;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.util.DateTimeUtil;
import com.bjpowernode.crm.util.SqlSessionUtil;
import com.bjpowernode.crm.util.UUIDUtil;
import com.bjpowernode.crm.workbench.dao.*;
import com.bjpowernode.crm.workbench.domain.*;
import com.bjpowernode.crm.workbench.service.GoodsService;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.junit.Test;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import java.util.List;

public class test {
    @Test
    public void test1(){
        String config = "conf/applicationContext.xml";
        ApplicationContext ac = new ClassPathXmlApplicationContext(config);
        SqlSessionTemplate sqlSessionTemplate = (SqlSessionTemplate)ac.getBean("sqlSessionTemplate");
       Class c =  sqlSessionTemplate.getClass();
        System.out.println(c.getName());
        UserDao userDao = (UserDao)sqlSessionTemplate.getMapper(UserDao.class);
        User user =  userDao.login("zs","202cb962ac59075b964b07152d234b70");
        System.out.println(user);
    }

    @Test
    public void testTrans(){
        String config = "conf/applicationContext.xml";
        ApplicationContext ac = new ClassPathXmlApplicationContext(config);
        String[] names =ac.getBeanDefinitionNames();
        for(String name:names){
            System.out.println(name);
        }

        /*GoodsService service = (GoodsService)ac.getBean("goodsServiceImpl");
        boolean flag = service.testTrans("A0001");
        System.out.println(flag? "删除成功":"删除失败");*/
    }

    @Test
    public void testUUID(){
        String id = UUIDUtil.getUUID();
        System.out.println(id);
    }

    @Test
    public void testConvert(){
        String config   = "conf/applicationContext.xml";
        ApplicationContext ac = new ClassPathXmlApplicationContext(config);
        SqlSessionFactory factory = (SqlSessionFactory)ac.getBean("sqlSessionFactory");
        SqlSession sqlSession = factory.openSession();

        TranDao tranDao = sqlSession.getMapper(TranDao.class);
        TranRemarkDao tranRemarkDao = sqlSession.getMapper(TranRemarkDao.class);
        TranHistoryDao tranHistoryDao = sqlSession.getMapper(TranHistoryDao.class);
        ContactsDao contactsDao = sqlSession.getMapper(ContactsDao.class);
        ContactsRemarkDao contactsRemarkDao = sqlSession.getMapper(ContactsRemarkDao.class);

        String [] id = new String[2];
        id[0] = "d4777c6ddaf2456c9aef097bbfcf90ca";
        id[1] = "d4777c6ddaf2456c9aef097bbfcf90cf";

        List<String> tid = tranDao.getTidByCid(id);//相关交易的id

        if (tid.size()!=0){

            //==================================交易备注=======================================
            int count5 =  tranRemarkDao.getCountByTid(tid);
            int count6 =  tranRemarkDao.deleteByTid(tid) ;

            System.out.println("count5:"+count5);
            System.out.println("count6:"+count6);

            //==================================交易历史=======================================

            int count7 =  tranHistoryDao.getCountByTid(tid);
            int count8 =  tranHistoryDao.deleteByTid(tid) ;

            System.out.println("count7:"+count7);
            System.out.println("count8:"+count8);




            //==================================交易======================================
            int count9 = tranDao.getCountByCid(id);
            int count10 = tranDao.deleteTranByCid(id);

            System.out.println("count9:"+count9);
            System.out.println("count10:"+count10);
        }




    //==================================联系人=======================================
        List<String> contactsId = contactsDao.getContactIdByCid(id);

        if(contactsId.size()!=0){
            int count11 = contactsRemarkDao.getCountByContactId(contactsId);
            int count12 = contactsRemarkDao.deleteByContactId(contactsId);
            System.out.println("count11:"+count11);
            System.out.println("count12:"+count12);

            //删除联系人
            int count13 = contactsDao.getContactByCid(id);
            int count14 = contactsDao.deleteContactByCid(id);
            System.out.println("count13:"+count13);
            System.out.println("count14:"+count14);
        }

    }

    @Test
    public void testLogin(){
        String config   = "conf/applicationContext.xml";
        ApplicationContext ac = new ClassPathXmlApplicationContext(config);
        UserService service = (UserService)ac.getBean("userServiceImpl");
        String loginAct = "zs";     //正确输入账号
        String loginPwd = "369";    //正确输入密码
        String ip = "127.0.0.1";
        User user  = service.login(loginAct,loginPwd,ip);
        if(user != null){
            System.out.println("登陆成功！！！");
        }else {
            System.out.println("登陆失败！！！");
        }
    }

    @Test
    public void testSpring(){
        String config = "conf/applicationContext.xml";
        ClassPathXmlApplicationContext ac = new ClassPathXmlApplicationContext(config);
        String [] names = ac.getBeanDefinitionNames();
        for(String name:names){
            System.out.println(name);
        }
    }
}
