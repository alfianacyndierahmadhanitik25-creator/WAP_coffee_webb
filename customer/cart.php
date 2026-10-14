
<?php
session_start();

if (
    !isset($_SESSION['user_id'], $_SESSION['role']) ||
    $_SESSION['role'] !== 'customer'
) {
    header('Location: ../login.php');
    exit;
}

function e($value): string {
    return htmlspecialchars((string)$value, ENT_QUOTES, 'UTF-8');
}

function rupiah($value): string {
    return 'Rp ' . number_format((float)$value, 0, ',', '.');
}

$cart = $_SESSION['cart'] ?? [];
$total = 0;
?>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Cart | LŪMA Café</title>
    <link rel="stylesheet" href="luma_moments.css">
</head>
<body>

<main class="container section">
    <a href="luma_moments.php" class="text-link">← Back to Moments</a>

    <div class="section-heading" style="margin-top: 24px">
        <div>
            <span class="eyebrow">YOUR SELECTION</span>
            <h2>Your Cart</h2>
            <p>Periksa pilihanmu sebelum melanjutkan checkout.</p>
        </div>
    </div>

    <?php if (!$cart): ?>

        <div class="empty-state">
            <h3>Your cart is waiting.</h3>
            <p>Belum ada menu di keranjangmu.</p>
            <a href="luma_moments.php" class="text-link">
                Discover your moment →
            </a>
        </div>

    <?php else: ?>

        <div class="orders-list">
            <?php foreach ($cart as $key => $item): ?>
                <?php
                $subtotal = (float)$item['price'] * (int)$item['quantity'];
                $total += $subtotal;
                ?>

                <article class="order-card">
                    <div class="order-top">
                        <div>
                            <strong><?= e($item['menu_name']) ?></strong>
                            <p>Size: <?= e(ucfirst($item['size'])) ?></p>
                            <p>Quantity: <?= (int)$item['quantity'] ?></p>
                        </div>

                        <strong><?= e(rupiah($subtotal)) ?></strong>
                    </div>

                    <p>
                        <?= e(rupiah($item['price'])) ?> per item
                    </p>
                </article>
            <?php endforeach; ?>
        </div>

        <div class="rewards-card" style="margin-top: 24px">
            <div>
                <span class="reward-label">TOTAL</span>
                <div class="points-number">
                    <?= e(rupiah($total)) ?>
                </div>
            </div>

            <div class="reward-level">
                <a href="checkout.php" class="btn-primary">
                    Continue to Checkout →
                </a>
            </div>
        </div>

    <?php endif; ?>
</main>

</body>
</html>
