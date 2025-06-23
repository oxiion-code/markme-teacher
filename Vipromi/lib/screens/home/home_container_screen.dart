import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';


import '../widgets/coloured_container.dart';

class HomeContainer extends StatelessWidget {
  const HomeContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( // Enable vertical scrolling
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [Colors.black, Colors.black45],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: GestureDetector(
                      onTap: (){
                        context.push('/products');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Shop Now ',
                            style: GoogleFonts.inriaSans(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Colors.blue[100                         ],
                            ),
                            textAlign: TextAlign.end,
                          ),
                          SizedBox(width: 10,),
                          Icon(Icons.arrow_circle_right,color: Colors.white,)
                        ],
                      ),
                    ),
                  ),
                  Text(
                    'VIPROMI',
                    style: GoogleFonts.inriaSans(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'The Only Cattle-Feed Solution You Need',
                    style: GoogleFonts.inriaSans(
                      fontSize: 14,
                      color: Colors.grey[100],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Our Specializations',
            style: GoogleFonts.inriaSans(
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 12),
          // Horizontal scrolling Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ColouredContainer(
                  colors: [Colors.blueGrey, Colors.deepOrangeAccent],
                  text: 'Nutritional Excellence',
                ),
                SizedBox(width: 10),
                ColouredContainer(
                  colors: [Colors.green, Colors.blue],
                  text: 'Nutritional Excellence',
                ),
                SizedBox(width: 10),
                ColouredContainer(
                  colors: [Colors.deepPurple, Colors.green],
                  text: 'Innovation and Research',
                ),
                SizedBox(width: 10),
                ColouredContainer(
                  colors: [Colors.green, Colors.orangeAccent],
                  text: 'Education and Training',
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
          // Another row with horizontal scrolling
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ColouredContainer(
                  colors: [Colors.red, Colors.green],
                  text: 'Collaboration and Partnerships',
                ),
                SizedBox(width: 10),
                ColouredContainer(
                  colors: [Colors.blueAccent, Colors.orangeAccent],
                  text: 'Sustainability',
                ),
                SizedBox(width: 10),
                ColouredContainer(
                  colors: [Colors.deepPurple, Colors.green],
                  text: 'Quality Assurance',
                ),
                SizedBox(width: 10),
                ColouredContainer(
                  colors: [Colors.green, Colors.orangeAccent],
                  text: 'Ethical Business Practices',
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
          // Another row with horizontal scrolling
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ColouredContainer(
                  colors: [Colors.deepPurple, Colors.green],
                  text: 'Farmer Empowerment',
                ),
                SizedBox(width: 10),
                ColouredContainer(
                  colors: [Colors.green, Colors.blueAccent],
                  text: 'Continuous Improvement',
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
          Text(
            'About Us',
            style: GoogleFonts.inriaSans(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          Text(
            "It's important for our company to define its mission based on its unique vision, capabilities, and the specific needs of the Indian cattle industry. Our mission statement is serving as a guiding principle, reflecting the company's commitment to serving customers, driving innovation, and contributing to the overall growth and development of the cattle sector in India.",
            style: GoogleFonts.inriaSans(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
