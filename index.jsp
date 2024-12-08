<%@ page import="com.learn.mycart.helper.Helper" %>
<%@ page import="com.learn.mycart.dao.CategoryDao" %>
<%@ page import="com.learn.mycart.dao.ProductDao" %>
<%@ page import="com.learn.mycart.helper.FactoryProvider" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.learn.mycart.entities.*" %>
<html>
<head>
    <title>Farming Portal</title>
    <style>
    body {
        background-color: #000080; /* Navy blue background */
        color: #000000; /* Black text */
        font-family: Arial, sans-serif;
        margin: 0;
        padding: 0;
    }

    .container-fluid {
        padding: 0;
    }

    .list-group-item {
        background-color: #000080; /* Navy blue background */
        color: #FFFF00; /* Yellow text */
        border: 1px solid #FFFF00; /* Yellow border */
        cursor: pointer;
    }

    .list-group-item:hover {
        background-color: #FFFF00; /* Yellow background */
        color: #000000; /* Black text */
    }

    .card {
        background-color: #000080; /* Navy blue background */
        color: #000000; /* Yellow text */
        border: 1px solid #000000; /* Yellow border */
        transition: transform 0.3s ease, box-shadow 0.3s ease;
        border-radius: 10px;
        margin-bottom: 20px;
    }

    .card:hover {
        transform: scale(1.05);
        box-shadow: 0px 4px 10px rgba(255, 255, 0, 0.6);
    }

    .card-img-top {
        object-fit: cover; /* Ensures the image fills the container */
        width: 100%;
        height: 250px; /* Adjust height */
        cursor: pointer;
    }

    .card-footer .btn {
        background-color: #000080; /* Navy blue background */
        color: #FFFF00; /* Yellow text */
        border: 1px solid #FFFF00; /* Yellow border */
    }

    .card-footer .btn:hover {
        background-color: #FFFF00; /* Yellow background */
        color: #000000; /* Black text */
    }

    .modal-content {
        background-color: #333333; /* Dark grey background */
        color: #FFFF00; /* Yellow text */
    }

    .modal-header, .modal-footer {
        background-color: #000080; /* Navy blue background */
        color: #FFFF00; /* Yellow text */
    }

    .modal-body img {
        object-fit: contain; /* Ensures the image is fully visible */
        max-width: 100%;
        max-height: 500px; /* Limit the max height to avoid very large images */
        margin: auto; /* Center the image */
    }
    .carousel-inner .carousel-item {
        height: 425px; /* Set equal size for all slides */
    }
    .carousel-inner .carousel-item img {
    height: 100%;
    object-fit: auto; /* Ensure the image is fully visible */
}
    

   
    footer {
        background-color: #000000; /* Black background */
        color: #FFFF00; /* Yellow text */
        text-align: center;
        padding: 20px;
    }
.btn-social-icon {
    font-size: 24px;
    padding: 10px;
    margin-right: 10px;
}

    </style>
    <%@ include file="components/common_css_js.jsp" %>
    <!-- Include FontAwesome for icons -->
<script src="https://kit.fontawesome.com/a076d05399.js"></script>
</head>
<body>
    <%@ include file="components/navbar.jsp" %>

    <%
        String cat = request.getParameter("category");
        List<Product> list = new ArrayList<>();

        ProductDao dao = new ProductDao(FactoryProvider.getFactory());

        if (cat == null || cat.trim().equals("all")) {
            list = dao.getAllProducts();
        } else {
            try {
                int cid = Integer.parseInt(cat.trim());
                list = dao.getAllProductsById(cid);
            } catch (NumberFormatException e) {
                e.printStackTrace();
                list = new ArrayList<>();
            }
        }

        CategoryDao cdao = new CategoryDao(FactoryProvider.getFactory());
        List<Category> clist = cdao.getCategories();
        if (clist == null) {
            clist = new ArrayList<>();
        }
    %>

    <!-- Slideshow Section -->
    <div id="customSlideshow" class="carousel slide mt-4" data-ride="carousel" data-interval="5000">
        <div class="carousel-inner">
            <div class="carousel-item active">
                <img class="d-block w-100" src="img/s1.jpg" alt="Dhokra Craft">
            </div>
            <div class="carousel-item">
                <img class="d-block w-100" src="img/s2.jpg" alt="Gond Painting">
            </div>
            <div class="carousel-item">
                <img class="d-block w-100" src="img/s3.jpg" alt="Slide 3">
            </div>
        </div>
        <a class="carousel-control-prev" href="#customSlideshow" role="button" data-slide="prev">
            <span class="carousel-control-prev-icon" aria-hidden="true"></span>
            <span class="sr-only">Previous</span>
        </a>
        <a class="carousel-control-next" href="#customSlideshow" role="button" data-slide="next">
            <span class="carousel-control-next-icon" aria-hidden="true"></span>
            <span class="sr-only">Next</span>
        </a>
    </div>

    <div class="container-fluid mt-4">
        <div class="row">
            <!-- Sidebar Section -->
            <div class="col-md-2">
                <div class="list-group mt-4">
                    <a href="index.jsp?category=all" class="list-group-item list-group-item-action active">All Products</a>
                    <%
                        for (Category c : clist) {
                    %>
                    <a href="index.jsp?category=<%= c.getCategoryId() %>" class="list-group-item list-group-item-action">
                        <%= c.getCategoryTitle() %>
                    </a>
                    <%
                        }
                    %>
                </div>
            </div>

            <!-- Main Product Display Section -->
            <div class="col-md-10">
                <div class="row mt-4">
                    <div class="col-md-12">
                        <div class="card-columns">
                            <%
                            if (list != null && !list.isEmpty()) {
                                for (Product p : list) {
                            %>
                            <div class="card">
                                <img src="img/products/<%= p.getpPhoto() %>" class="card-img-top" alt="Product Image" data-toggle="modal" data-target="#imageModal" onclick="showImage('img/products/<%= p.getpPhoto() %>')">
                                <div class="card-body">
                                    <h5 class="card-title"><%= p.getpName() %></h5>
                                    <p class="card-text"><%= Helper.get10Words(p.getpDesc()) %></p>
                                </div>
                                <div class="card-footer text-center">
                                    <button class="btn" onclick="add_to_cart(<%= p.getPid() %>, '<%= p.getpName() %>', '<%= p.getPriceAfterApplyDiscount() %>')">
                                        Add to Cart
                                    </button>
                                    <button class="btn">
                                        &#8377; <%= p.getPriceAfterApplyDiscount() %>/- 
                                        <span class="text-secondary discount-label">
                                            &#8377;<%= p.getpPrice() %> <%= p.getpDiscount() %>%
                                        </span>
                                    </button>
                                </div>
                            </div>
                            <%
                                }
                            } else {
                            %>
                            <h3>No items in this category</h3>
                            <%
                            }
                            %>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Image Modal -->
    <div class="modal fade" id="imageModal" tabindex="-1" role="dialog" aria-labelledby="imageModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="imageModalLabel">Product Image</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body text-center">
                    <img id="modalImage" src="" alt="Product Image" class="img-fluid">
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <%@ include file="components/common_modals.jsp" %>

    <script>
        function showImage(src) {
            document.getElementById('modalImage').src = src;
        }
    </script>

    <!-- Footer -->
    <!-- Footer Section -->
<footer class="bg-black text-white py-5 mt-5">
    <div class="container">
        <!-- Newsletter Section -->
        <div class="row mb-4">
            <div class="col-md-6">
                <h5>Newsletter</h5>
                <p>Subscribe to get information about products and coupons</p>
                <input type="email" class="form-control mb-3" placeholder="Email Address">
                <button class="btn btn-warning">Subscribe</button>
            </div>
            <div class="col-md-6">
                <h5>Customer Benefits</h5>
                <ul>
                    <li><strong>Free Delivery</strong> for all orders over ₹999</li>
                    <li><strong>15 Days Return</strong> if goods have problems</li>
                    <li><strong>Secure Payment</strong> 100% secure payment</li>
                    <li><strong>24/7 Support</strong> Dedicated support</li>
                </ul>
            </div>
        </div>

        
       <!-- Contact Section -->
<div class="row mb-4 justify-content-center">
    <div class="col-md-6">
        <h5>Contact Us</h5>
        <p><strong>Call us</strong> 9:00 AM - 6:00 PM IST</p>
        <p>+91-995-8453-908</p>
        <p>Tribes India (TRIFED), Beej Bhavan, Pusa Complex, Vijaywada 110012 India</p>
        <p>Email: <a href="mailto:ecom.tribesindia@gmail.com">ecom.tribesindia@gmail.com</a></p>
    </div>
    <div class="col-md-6">
       <h5>Follow Us</h5>
<a href="#" class="btn btn-social-icon btn-facebook">
    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <path d="M18 2h-3a6 6 0 0 0-6 6v3H6v4h3v10h4V15h3l1-4h-4V8a1 1 0 0 1 1-1h3V2z"></path>
    </svg>
</a>
<a href="#" class="btn btn-social-icon btn-instagram">
    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <circle cx="12" cy="12" r="4"></circle>
        <path d="M17 7h.01M16 4h4v16H4V4h12zm0 4V6a2 2 0 0 0-2-2H6a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2v-4z"></path>
    </svg>
</a>
<a href="#" class="btn btn-social-icon btn-whatsapp">
    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <path d="M21 12.5c0 4.7-3.8 8.5-8.5 8.5-2.6 0-4.9-1.2-6.5-3.1l-5 1.6 1.5-5c-1.9-1.7-3-4.1-3-6.6C2 5.8 5.8 2 9.5 2 13.3 2 17 4.2 17 7.8c0 1.5-.5 2.8-1.4 3.8l-.9 1.1c-.3.4-.1.9.2 1.2l1.3 1.2c.6.5 1.4.4 1.8-.1 1-1.2 1.6-2.7 1.6-4.2 0-4.7-3.8-8.5-8.5-8.5S1 7.8 1 12.5c0 3.6 2.4 6.7 5.9 7.8l-.6 2.2 2.3-.7c.9.5 1.9.9 3 1.2-.5-.9-.8-1.8-.8-2.8 0-3.2 2.6-5.8 5.8-5.8 3.1 0 5.7 2.6 5.7 5.8z"></path>
    </svg>
</a>

    </div>
</div>

<!-- Copyright Section -->
<div class="row justify-content-center">
    <div class="col-12 text-center">
        <p>&copy; 2024 Tribes India (TRIFED). All rights reserved.</p>
    </div>
</div>

</footer>



</body>
</html>
