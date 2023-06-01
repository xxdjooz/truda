/// flutter pub run build_runner build
/// 建立好数据模型要运行下上面命令生成ObjectBox binding code
/// 文档 https://docs.objectbox.io/entity-annotations
///
///

// https://docs.objectbox.io/queries
// Query<User> query = userBox.query(User_.firstName.equals('Joe')).build();
// List<User> joes = query.find();
// query.close();

//Query<User> query = userBox.query(
//     User_.firstName.equals('Joe') &
//     User_.yearOfBirth.greaterThan(1970) &
//     User_.lastName.startsWith('O')).build();
// List<User> youngJoes = query.find();

//Query<User> query = userBox.query(User_.firstName.equals('Joe')).build();
// List<User> joes = query.find();
// query.close();

// Query<User> query = userBox.query(
//             User_.firstName.equal('Joe')
//             .and(User_.yearOfBirth.greaterThan(1970))
//             .and(User_.lastName.startsWith('O')))
//         .build();
//
// // or use operator overloads:
// Query<User> query = userBox.query(
//             User_.firstName.equal('Joe') &
//             User_.yearOfBirth.greaterThan(1970) &
//             User_.lastName.startsWith('O'))
//         .build();

// Query<User> query = box.query(
//     User_.firstName.equal('Joe')
//         .and(User_.age.lessThan(12)
//         .or(User_.stamp.oneOf([1012]))))
//     .order(User_.age)
//     .build();

// // in ascending order, ignoring case
// final qBuilder = box.query(User_.firstName.equals('Joe')..order(User_.lastName);
// final query = qBuilder.build();

// .order(User_.lastName, flags: Order.descending | Order.caseSensitive)

// // return all entities matching the query
// List<User> joes = query.find();
//
// // return only the first result or null if none
// User joe = query.findFirst();
//
// // return the only result or null if none, throw if more than one result
// User joe = query.findUnique();