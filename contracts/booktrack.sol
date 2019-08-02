pragma solidity ^0.4.24;

import "./author.sol";
import "./publisher.sol";

contract BookTrack is Author, Publisher {

    uint private _isbn;

    enum State {
        Written,
        Reviewed,
        Bought,
        Sold,
        Published
    }

    struct Book {
        uint isbn;
        string title;
        address owner;
        uint price;
        State state;
        address author;
        address publisher;
    }

    mapping (uint => Book) private books;

    event Written(uint isbn);
    event Reviewed(uint isbn);
    event Bought(uint isbn);
    event Sold(uint isbn);
    event Published(uint isbn);

    modifier written(uint isbn) {
        require(books[isbn].state == State.Written);
        _;
    }

    modifier reviewed(uint isbn) {
        require(books[isbn].state == State.Reviewed);
        _;
    }

    modifier bought(uint isbn) {
        require(books[isbn].state == State.Bought);
        _;
    }

    modifier sold(uint isbn) {
        require(books[isbn].state == State.Sold);
        _;
    }

    modifier paidEnough(uint isbn) {
        require(msg.value >= books[isbn].price);
        _;
    }

    modifier checkValue(uint isbn) {
        uint price = books[isbn].price;
        uint change = msg.value - price;
        books[isbn].publisher.transfer(change);
        _;
    }

    constructor() public {
        _isbn = 1;
    }

    function addBook(string memory title, uint price) public onlyAuthor {
        books[_isbn] = Book({
            isbn: _isbn,
            title: title, 
            owner: msg.sender, 
            price: price, 
            author: msg.sender, 
            state: State.Written,
            publisher: address(0)});

        emit Written(_isbn);

        _isbn = _isbn + 1;
    }

    function reviewBook(uint isbn) public onlyPublisher written(isbn) {
        books[isbn].state = State.Reviewed;
        books[isbn].author = msg.sender;

        emit Reviewed(isbn);
    }

    function buyBook(uint isbn) public payable onlyPublisher reviewed(isbn) paidEnough(isbn) checkValue(isbn) {
        books[isbn].state = State.Bought;

        emit Bought(isbn);
    }

    function sellBook(uint isbn) public onlyAuthor bought(isbn) {
        books[isbn].state = State.Sold;
        books[isbn].owner = books[isbn].publisher;

        emit Sold(isbn);
    }

    function publishBook(uint isbn) public onlyPublisher sold(isbn) {
        books[isbn].state = State.Published;

        emit Published(isbn);
    }

}