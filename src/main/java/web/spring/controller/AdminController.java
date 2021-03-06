package web.spring.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import lombok.Setter;
import lombok.extern.log4j.Log4j;
import web.spring.service.FileService;
import web.spring.service.PaymentService;
import web.spring.service.ProductService;
import web.spring.service.UserService;
import web.spring.vo.Criteria;
import web.spring.vo.FileVO;
import web.spring.vo.OrderVO;
import web.spring.vo.PBoardVO;
import web.spring.vo.PageNavi;
import web.spring.vo.ProductVO;
import web.spring.vo.UserVO;

@Controller
@Log4j
public class AdminController {
	@Setter(onMethod_= @Autowired)
	private ProductService productService;
	
	@Setter(onMethod_= @Autowired)
	private UserService userService;
	
	@Setter(onMethod_= @Autowired)
	private FileService fileService;
	
	@Autowired
	private PaymentService paymentService;
	
	//주문관리
	@GetMapping("/admin/orderAllList")
	public String orderAllList(Model model, HttpServletRequest rq, OrderVO ovo, Criteria cri, UserVO uvo, PBoardVO pBoard) {
		HttpSession session = rq.getSession();
		UserVO user = (UserVO)session.getAttribute("user");
		if(user != null) {
			if(user.getUser_type().equals("1")) { 
				List<OrderVO> list = paymentService.getOrderComList(user.getUser_id(), cri);
				log.info(list);
				model.addAttribute("list", list);
				model.addAttribute("pageNavi", new PageNavi(cri, paymentService.getOrderComListTotal(user.getUser_id(), cri)));
				System.out.println("pboard_user_id============" + user.getUser_id());
			} else {
				List<OrderVO> list = paymentService.getOrderAllList(cri);
				model.addAttribute("list", list);
				model.addAttribute("pageNavi",new PageNavi(cri, paymentService.getOrderAllListTotal(cri)));
			}
			
			return "/admin/orderAllList";
		}
		return "/member/login";
	}
	
	//상품관리
	@GetMapping("/admin/productControl")
	public String getProductList(Criteria cri, Model model) {
		List<ProductVO> productList = productService.getProductList(cri);
		
		List<ProductVO> productarr = productService.getProductAllList();
		ArrayList<String> product_list = new ArrayList<String>();
		Map<String, Object> product_Map = new HashMap<String, Object>();
		(productarr).forEach(a->product_list.add(a.getFile_pictureId()));
		/*
		 * for(String a : product_list) { System.out.println(a); }
		 */
		product_Map.put("product_Map", product_list);
		if(productList.size()>0) {
			List<FileVO> fileList = fileService.getListFileAdmin(product_Map);
			model.addAttribute("fileList", fileList);
			log.info(fileList);
		}
		model.addAttribute("productList", productList);
		model.addAttribute("pageNavi",new PageNavi(cri, productService.getProductTotal(cri)));
		return "/admin/productManage";
	}
	
	//상품 관리글 관리
	@GetMapping("/admin/pBoardControl")
	public String getPBoardList(Criteria cri, Model model) {
		//String temp = cri.getOrderby().substring(cri.getOrderby().lastIndexOf("_")+1);
		if(cri.getOrderby().matches("asc")) {
			cri.setOrderby(cri.getOrderby()+"_desc");
		} else {
			cri.setOrderby(cri.getOrderby());
		}
		log.info(cri.getOrderby());
		List<UserVO> userList = userService.getUserList();
		List<ProductVO> productList = productService.getProductAllList();
		List<PBoardVO> PBoardList = productService.getAllPBoardList(cri);
		ArrayList<String> board_list = new ArrayList<String>();
		Map<String, Object> product_Map = new HashMap<String, Object>();
		(PBoardList).forEach(a->board_list.add(a.getFile_pictureId()));
		product_Map.put("product_Map", board_list);
		List<FileVO> fileList = fileService.getListFileAdmin(product_Map);
		model.addAttribute("fileList", fileList);
		model.addAttribute("PBoardList", PBoardList);
		model.addAttribute("productList", productList);
		model.addAttribute("userList", userList);
		model.addAttribute("pageNavi",new PageNavi(cri,productService.getTotal(cri)));
		return "/admin/pBoardManage";
	}
	
	//기업회원 // 상품 관리글 관리
	@GetMapping("/product/pBoardUpdate")
	public String getUserPBoardList(Criteria cri, Model model, HttpServletRequest req) {
		HttpSession session = req.getSession();
		if(session.getAttribute("user") != null) {
		UserVO user = (UserVO) session.getAttribute("user");
		log.info(user);
			if(user!=null) {
				if(cri.getOrderby().matches("asc")) {
					cri.setOrderby(cri.getOrderby()+"_desc");
				} else {
					cri.setOrderby(cri.getOrderby());
				}
				log.info("기업"+cri.getOrderby());
				List<ProductVO> productList = productService.getProductAllList();
				List<PBoardVO> PBoardList = productService.getUserPBoardList(user.getUser_id(), cri);
				log.info("PBoardList"+PBoardList);
				if(PBoardList!=null) {
					model.addAttribute("PBoardList", PBoardList);
					model.addAttribute("productList", productList);
					model.addAttribute("pageNavi",new PageNavi(cri, productService.getPboardUserTotal(user.getUser_id(), cri)));
					return "/admin/pBoardUpdate";
				}
			} 
		} 
		return "member/login";
	}//
	
	//유저관리
	@GetMapping("/admin/userControl")
	public String getUserList(Criteria cri, Model model, HttpServletRequest req) {
		HttpSession session = req.getSession();
		UserVO user = (UserVO) session.getAttribute("user");
		if(user.getUser_type().equals("0")) {
			List<UserVO> userArr = userService.getAllUser();
			ArrayList<String> user_list = new ArrayList<String>();
			Map<String, Object> user_Map = new HashMap<String, Object>();
			(userArr).forEach(a->user_list.add(a.getFile_pictureId()));
			user_Map.put("product_Map", user_list);
			List<FileVO> fileList = fileService.getListFileAdmin(user_Map);
			List<UserVO> userList = userService.getAllUserList(cri);
			if(userList.size()>0) {
				log.info("userAd"+userList);
				model.addAttribute("pageNavi", new PageNavi(cri, userService.getUserTotal(cri)));
				model.addAttribute("userList", userList);
				model.addAttribute("fileList", fileList);
			}
			return "/admin/userControl";
		}
		return "/login";
	}
}
