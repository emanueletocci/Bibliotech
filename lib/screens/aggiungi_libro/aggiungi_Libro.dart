import 'package:flutter/material.dart';
class aggiungiLibro extends StatelessWidget {
    const aggiungiLibro({super.key});

    @override
    Widget build(BuildContext contest) {
        return Scaffold( 
        body: SingleChildScrollView(
            child: Column(
                children: [Container(
                   padding: const EdgeInsets.symmetric(vertical:40, horizontal: 20),
                   color: Theme.of(context).colorScheme.primary,
                   child:
                   Row(mainAxisAlignment: mainAxisAlignment.center, children: [
                    Expanded(
                        child: Column(
                            mainAxisAlignment: mainAxisAlignment.center,
                            children: [
                                SizedBox(height: 20),
                                Row(
                                    crossAxisAlignment: crossAxisAlignment.center ,
                                    mainAxisAlignment: mainAxisAlignment.spaceBetween,
                                    children: [
                                        backButton(),
                                        Test(
                                            "back",
                                            style: Theme.of(context).textTheme.bodyLarge
                                            ?.copyWith(
                                                color: Theme.of(context).colorScheme.background,
                                            ),
                                        ), //Text
                                        SizeBox(width: 70)
                                    ],
                                    ),
                                    SizeBoxing(height: 60),
                                   Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                                   ClipRRect(
                                                        borderRadius: BorderRadius.circular(100),
                                                        child: Image.asset( fit: BoxFit.cover,),
                                                    ),
                                                  )
                                    )
                            ]
                        )
                    )

        )
        )
        );

    }
}