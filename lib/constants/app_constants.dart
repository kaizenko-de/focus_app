import 'package:flutter/material.dart';
import 'package:focus/constants/app_colors.dart';

class AppConstants {
  static final friends = [
    {
      'name': 'Alicia M.',
      'avatar': 'https://randomuser.me/api/portraits/women/1.jpg',
      'status': 'Online',
      'statusIcon': Icons.circle,
      'statusColor': AppColors.defaultLime.withAlpha(100),
      'statusTextColor': AppColors.defaultLime,
      'statusSub': null,
      'nextEvent': 'Tomorrow Land',
    },
    {
      'name': 'Alicia M.',
      'avatar': 'https://randomuser.me/api/portraits/women/2.jpg',
      'status': 'At Event',
      'statusIcon': Icons.location_pin,
      'statusColor': AppColors.error400.withAlpha(100),
      'statusTextColor': AppColors.error400,
      'statusSub': null,
      'nextEvent': 'Tomorrow Land',
    },
    {
      'name': 'Alicia M.',
      'avatar': 'https://randomuser.me/api/portraits/men/3.jpg',
      'status': 'Offline',
      'statusIcon': Icons.circle,
      'statusColor': AppColors.black,
      'statusTextColor': AppColors.black,
      'statusSub': null,
      'nextEvent': 'Tomorrow Land',
    },
  ];

   static final sosContacts = [
    {
      'name': 'Alicia M.',
      'avatar': 'https://randomuser.me/api/portraits/women/1.jpg',
      'contact': '+1 555-123-4567',
    },
    {
      'name': 'Ben T.',
      'avatar': 'https://randomuser.me/api/portraits/women/2.jpg',
      'contact': '+1 555-987-6543',
    },
    {
      'name': 'Carla S.',
      'avatar': 'https://randomuser.me/api/portraits/men/3.jpg',
      'contact': '+1 555-555-1212',
    },
  ];

  static final groups = [
    {
      'name': 'Straight Walkers',
      'avatars': [
        'https://randomuser.me/api/portraits/men/1.jpg',
        'https://randomuser.me/api/portraits/men/2.jpg',
        'https://randomuser.me/api/portraits/men/3.jpg',
        'https://randomuser.me/api/portraits/women/4.jpg',
      ],
      'extra': 3,
    },
    {
      'name': 'Straight Walkers',
      'avatars': [
        'https://randomuser.me/api/portraits/men/5.jpg',
        'https://randomuser.me/api/portraits/men/6.jpg',
        'https://randomuser.me/api/portraits/men/1.jpg',
        'https://randomuser.me/api/portraits/men/7.jpg',
      ],
      'extra': 5,
    },
  ];

  static final upcomingEvents = [
    {
      'id': '1',
      'title': 'Walk + Chill.',
      'subtitle': 'July 20 | 5:00 PM | 3.2 km loop',
      'buttonText': 'Join Event',
    },
    {
      'id': '2',
      'title': 'Racer.',
      'subtitle': 'July 21 | 5:00 PM | 3.2 km loop',
      'buttonText': 'Join Event',
    },
    {
      'id': '3',
      'title': 'Fun Run.',
      'subtitle': 'July 22 | 6:00 PM | 5 km loop',
      'buttonText': 'Join Event',
    },
  ];

  static final pastEvents = [
    {
      'id': '4',
      'title': 'Spring Dash.',
      'subtitle': 'June 10 | 4:00 PM | 2 km loop',
      'buttonText': 'View Results',
    },
    {
      'id': '5',
      'title': 'Night Walk.',
      'subtitle': 'June 15 | 8:00 PM | 4 km loop',
      'buttonText': 'View Results',
    },
    {
      'id': '6',
      'title': 'City Sprint.',
      'subtitle': 'June 18 | 7:00 PM | 3 km loop',
      'buttonText': 'View Results',
    },
  ];

  static final invitations = [
    {
      'groupName': 'Chill Pill',
      'invitedBy': 'Alicia M.',
      'message': "You're invited by Alicia M. to join this group",
      'avatars': [
        'https://randomuser.me/api/portraits/men/1.jpg',
        'https://randomuser.me/api/portraits/women/2.jpg',
        'https://randomuser.me/api/portraits/men/3.jpg',
        'https://randomuser.me/api/portraits/women/4.jpg',
      ],
      'extra': 3,
    },
    {
      'groupName': 'Step Squad',
      'invitedBy': 'Brian T.',
      'message': "You're invited by Brian T. to join this group",
      'avatars': [
        'https://randomuser.me/api/portraits/men/5.jpg',
        'https://randomuser.me/api/portraits/women/6.jpg',
        'https://randomuser.me/api/portraits/men/7.jpg',
        'https://randomuser.me/api/portraits/women/8.jpg',
      ],
      'extra': 2,
    },
    {
      'groupName': 'Night Racers',
      'invitedBy': 'Sophie L.',
      'message': "You're invited by Sophie L. to join this group",
      'avatars': [
        'https://randomuser.me/api/portraits/men/9.jpg',
        'https://randomuser.me/api/portraits/women/10.jpg',
        'https://randomuser.me/api/portraits/men/11.jpg',
        'https://randomuser.me/api/portraits/women/12.jpg',
      ],
      'extra': 4,
    },
  ];

  static final groupsJoinable = [
    {
      'groupName': 'Straight Walkers',
      'avatars': [
        'https://randomuser.me/api/portraits/men/1.jpg',
        'https://randomuser.me/api/portraits/women/2.jpg',
        'https://randomuser.me/api/portraits/men/3.jpg',
        'https://randomuser.me/api/portraits/women/4.jpg',
      ],
      'extra': 3,
    },
    {
      'groupName': 'Urban Pacers',
      'avatars': [
        'https://randomuser.me/api/portraits/men/5.jpg',
        'https://randomuser.me/api/portraits/women/6.jpg',
        'https://randomuser.me/api/portraits/men/7.jpg',
        'https://randomuser.me/api/portraits/women/8.jpg',
      ],
      'extra': 2,
    },
    {
      'groupName': 'Moonlight Movers',
      'avatars': [
        'https://randomuser.me/api/portraits/men/9.jpg',
        'https://randomuser.me/api/portraits/women/10.jpg',
        'https://randomuser.me/api/portraits/men/11.jpg',
        'https://randomuser.me/api/portraits/women/12.jpg',
      ],
      'extra': 4,
    },
    {
      'groupName': 'Speedy Striders',
      'avatars': [
        'https://randomuser.me/api/portraits/men/13.jpg',
        'https://randomuser.me/api/portraits/women/14.jpg',
        'https://randomuser.me/api/portraits/men/15.jpg',
        'https://randomuser.me/api/portraits/women/16.jpg',
      ],
      'extra': 1,
    },
  ];

  static final List<Map<String, dynamic>> friendsGroup = [
    {
      'name': 'Alicia M.',
      'steps': '32,100 Steps',
      'avatar': 'https://randomuser.me/api/portraits/women/1.jpg',
    },
    {
      'name': 'Ben T.',
      'steps': '28,450 Steps',
      'avatar': 'https://randomuser.me/api/portraits/men/2.jpg',
    },
    {
      'name': 'Carla S.',
      'steps': '25,300 Steps',
      'avatar': 'https://randomuser.me/api/portraits/women/3.jpg',
    },
    {
      'name': 'David L.',
      'steps': '22,900 Steps',
      'avatar': 'https://randomuser.me/api/portraits/men/4.jpg',
    },
    {
      'name': 'Emma R.',
      'steps': '21,100 Steps',
      'avatar': 'https://randomuser.me/api/portraits/women/5.jpg',
    },
    {
      'name': 'Frank H.',
      'steps': '19,800 Steps',
      'avatar': 'https://randomuser.me/api/portraits/men/6.jpg',
    },
    {
      'name': 'Grace P.',
      'steps': '18,500 Steps',
      'avatar': 'https://randomuser.me/api/portraits/women/7.jpg',
    },
    {
      'name': 'Henry Q.',
      'steps': '17,200 Steps',
      'avatar': 'https://randomuser.me/api/portraits/men/8.jpg',
    },
    {
      'name': 'Ivy W.',
      'steps': '16,000 Steps',
      'avatar': 'https://randomuser.me/api/portraits/women/9.jpg',
    },
    {
      'name': 'Jack Z.',
      'steps': '15,400 Steps',
      'avatar': 'https://randomuser.me/api/portraits/men/10.jpg',
    },
  ];

  static final leaderboard = [
    {
      'rank': '9',
      'name': 'Samantha P.',
      'avatar': 'https://randomuser.me/api/portraits/women/10.jpg',
      'steps': '41,200',
    },
    {
      'rank': '10',
      'name': 'John D.',
      'avatar': 'https://randomuser.me/api/portraits/men/10.jpg',
      'steps': '39,800',
    },
    {
      'rank': '11',
      'name': 'Emily R.',
      'avatar': 'https://randomuser.me/api/portraits/women/2.jpg',
      'steps': '37,500',
    },
    {
      'rank': '12',
      'name': 'Carlos M.',
      'avatar': 'https://randomuser.me/api/portraits/men/2.jpg',
      'steps': '36,900',
    },
    {
      'rank': '13',
      'name': 'Priya S.',
      'avatar': 'https://randomuser.me/api/portraits/women/3.jpg',
      'steps': '35,400',
    },
    {
      'rank': '14',
      'name': 'David K.',
      'avatar': 'https://randomuser.me/api/portraits/men/4.jpg',
      'steps': '34,200',
    },
    {
      'rank': '15',
      'name': 'Alicia M.',
      'avatar': 'https://randomuser.me/api/portraits/women/4.jpg',
      'steps': '32,100',
    },
    {
      'rank': '16',
      'name': 'You',
      'avatar': 'https://randomuser.me/api/portraits/men/3.jpg',
      'steps': '28,450',
    },
    {
      'rank': '17',
      'name': 'Michael S.',
      'avatar': 'https://randomuser.me/api/portraits/men/5.jpg',
      'steps': '25,800',
    },
    {
      'rank': '18',
      'name': 'Linda T.',
      'avatar': 'https://randomuser.me/api/portraits/women/5.jpg',
      'steps': '24,100',
    },
  ];
}
